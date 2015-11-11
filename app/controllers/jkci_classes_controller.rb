class JkciClassesController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource param_method: :my_sanitizer

  def index
    @jkci_classes = @organisation.jkci_classes.includes([:batch]).active.all.order("id desc").page(params[:page])
    @batches = Batch.all
    respond_to do |format|
      format.html
      format.json {render json: {success: true, html: render_to_string(:partial => "jkci_class.html.erb", :layout => false, locals: {jkci_classes: @jkci_classes}), pagination_html:  render_to_string(partial: 'pagination.html.erb', layout: false, locals: {jkci_classes: @jkci_classes}), css_holder: ".jkciClassTable tbody"}}
    end
  end
  
  def new
    @standard = Standard.where(id: params[:standard_id]).first
    if @standard
      @jkci_class = @organisation.jkci_classes.build
      @teachers = @organisation.teachers
      @batches = Batch.all
    else
      redirect_to standards_path
    end
  end

  def show
    @jkci_class = @organisation.jkci_classes.where(id: params[:id]).first
    @students = @jkci_class.class_students.joins(:student).select("class_students.roll_number, students.*").where("students.is_disabled = false").order("class_students.roll_number asc, students.first_name asc")
    @chapters = []
    @daily_teaching_points = @jkci_class.daily_teaching_points.includes(:class_catlogs).chapters_points.order('id desc').page(params[:page])
    @teached_chapters = @daily_teaching_points.map(&:chapter_id).uniq
    @class_exams = @jkci_class.jk_exams.order("updated_at desc").page(params[:page])
    @notifications = @jkci_class.role_exam_notifications(current_user)
  end

  def create
    params.permit!
    @jkci_class = @organisation.jkci_classes.build(params[:jkci_class])
    if @jkci_class.save
      redirect_to jkci_classes_path
    end
  end

  def edit
    @jkci_class = @organisation.jkci_classes.where(id: params[:id]).first
    @teachers = @organisation.teachers
    @batches = Batch.all
  end

  def assign_students
    @jkci_class = @organisation.jkci_classes.where(id: params[:id]).first
    @selected_students = @jkci_class.students.map(&:id)
    @students = @jkci_class.standard.students.enable_students.where("id not in (?)", ([0] + @selected_students))
  end

  def manage_roll_number
    @jkci_class = @organisation.jkci_classes.where(id: params[:id]).first
    @students = @jkci_class.class_students.joins(:student).select("class_students.id, students.first_name, students.last_name, class_students.roll_number").order("class_students.roll_number asc, students.first_name asc")
  end

  def toggle_class_sms
    jkci_class = @organisation.jkci_classes.where(id: params[:id]).first
    if current_user.has_role? :manage_class_sms
      jkci_class.update_attributes({enable_class_sms: params[:value]})
    end
    render json: {success: true, id: jkci_class.id}
  end

  def toggle_exam_sms
    jkci_class = @organisation.jkci_classes.where(id: params[:id]).first
    if current_user.has_role? :manage_class_sms
      jkci_class.update_attributes({enable_exam_sms: params[:value]})
    end
    render json: {success: true, id: jkci_class.id}
  end
  
  def save_roll_number
    jkci_class = @organisation.jkci_classes.where(id: params[:id]).first
    jkci_class.save_class_roll_number(params[:roll_number])
    redirect_to jkci_class_path(jkci_class)
  end

  def manage_students
    jkci_class = @organisation.jkci_classes.where(id: params[:id]).first
    sutdents = params[:students_ids].map(&:to_i)  rescue []
    jkci_class.manage_students(sutdents, @organisation) if jkci_class
    render json: {success: true, id: jkci_class.id}
  end

  def remove_student_from_class
    jkci_class = @organisation.jkci_classes.where(id: params[:id]).first
    jkci_class.remove_student_from_class(params[:student_id], @organisation) if jkci_class
    render json: {success: true, id: jkci_class.id}
  end
  
  def update
    params.permit!
    @jkci_class = @organisation.jkci_classes.where(id: params[:id]).first
    if @jkci_class
      if @jkci_class.update(params[:jkci_class])
        redirect_to jkci_classes_path
      end
    end
  end
  
  def destroy
    jkci_class = @organisation.jkci_classes.where(id: params[:id]).first
    if jkci_class.destroy
      redirect_to jkci_classes_path
    end
  end

  def chapters
    @jkci_class = @organisation.jkci_classes.where(id: params[:jkci_class_id]).first
    @chapters = @jkci_class.chapters.select([:id, :name])
    @points = @chapters.first.chapters_points.select([:id, :name]) rescue []
    
    respond_to do |format|
      format.html
      format.json {render json: {success: true, chapters: @chapters,  points: @points} }
    end
  end
  
  def filter_class
    jkci_classes = @organisation.jkci_classes.includes([:batch]).all.order("id desc").page(params[:page])
    if params[:batch_id].present?
      jkci_classes = jkci_classes.where(batch_id: params[:batch_id])
    end
    
    render json: {success: true, html: render_to_string(:partial => "jkci_class.html.erb", :layout => false, locals: {jkci_classes: jkci_classes}), pagination_html:  render_to_string(partial: 'pagination.html.erb', layout: false, locals: {jkci_classes: jkci_classes}), css_holder: ".jkciClassTable tbody"}
  end


  def class_daily_teaches
    jkci_class = @organisation.jkci_classes.includes([:daily_teaching_points, :class_catlogs]).where(id: params[:id]).first
    @daily_teaching_points = jkci_class.daily_teaching_points.order('id desc')
    if params[:chapters].present?
      @daily_teaching_points = @daily_teaching_points.where(chapter_id: params[:chapters].split(',').map(&:to_i))
    end
    @daily_teaching_points = @daily_teaching_points.page(params[:page])
    respond_to do |format|
      format.html
      format.json {render json: {success: true, html: render_to_string(:partial => "daily_teaching_point.html.erb", :layout => false, locals: {daily_teaching_points: @daily_teaching_points}), pagination_html:  render_to_string(partial: 'daily_teach_pagination.html.erb', layout: false, locals: {class_daily_teach: @daily_teaching_points}),  css_holder: ".dailyTeach"}}
    end
  end
  
  def filter_class_exams
    @jkci_class = @organisation.jkci_classes.where(id: params[:id]).first
    @class_exams = @jkci_class.jk_exams.order("updated_at desc").page(params[:page])
    respond_to do |format|
      format.html
      format.json {render json: {success: true, html: render_to_string(:partial => "/exams/exam.html.erb", :layout => false, locals: {exams: @class_exams}), pagination_html:  render_to_string(partial: 'exam_pagination.html.erb', layout: false, locals: {class_exams: @class_exams}), css_holder: ".examsTable tbody"}}
    end
  end

  def filter_daily_teach
    @jkci_class = @organisation.jkci_classes.where(id: params[:id]).first
    @daily_teaching_points = @jkci_class.daily_teaching_points.includes(:class_catlogs).chapters_points.order('id desc')
    if params[:chapters].present?
      @daily_teaching_points = @daily_teaching_points.where(chapter_id: params[:chapters].split(',').map(&:to_i))
    end
    @daily_teaching_points = @daily_teaching_points.page(params[:page])
    respond_to do |format|
      format.html
      format.json {render json: {success: true, html: render_to_string(:partial => "daily_teaching_point.html.erb", :layout => false, locals: {daily_teaching_points: @daily_teaching_points, hide_edit: true}), pagination_html:  render_to_string(partial: 'daily_teach_pagination.html.erb', layout: false, locals: {class_daily_teach: @daily_teaching_points}), css_holder: ".dailyTeach tbody"}}
    end
  end

  def download_class_catlog
    @jkci_class = @organisation.jkci_classes.where(id: params[:id]).first
    @catlogs = @jkci_class.students_table_format(params[:subclass])
    respond_to do |format|
      format.pdf { render :layout => false }
    end
  end

  def download_class_syllabus
    @jkci_class = @organisation.jkci_classes.where(id: params[:id]).first
    @subjects = @jkci_class.standard.subjects
    #@subject = @jkci_class.standard.subjects.where(id: params[:subject]).first
    #@chapters_table = @jkci_class.chapters_table_format(@subject)
    respond_to do |format|
      format.pdf { render :layout => false }
    end
  end

  def download_class_student_list
    @jkci_class = @organisation.jkci_classes.where(id: params[:id]).first
    @students_table_format = @jkci_class.class_students_table_format
    respond_to do |format|
      format.pdf { render :layout => false }
    end
  end

  def sub_organisation_class_report
    @sub_organisation = @organisation.subtree.where(id: params[:sub_organisation_id]).first
    @jkci_class = @sub_organisation.jkci_classes.where(id: params[:jkci_class_id]).first
    @exams_table_format = @jkci_class.exams_table_format
    @daily_teaching_table_format = @jkci_class.daily_teaching_table_format
    respond_to do |format|
      format.pdf { render :layout => false }
    end
  end
  
  def my_sanitizer
    #params.permit!
    params.require(:jkci_class).permit!
  end
end
