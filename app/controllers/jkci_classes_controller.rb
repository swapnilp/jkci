class JkciClassesController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource param_method: :my_sanitizer

  def index
    @jkci_classes = JkciClass.includes([:batch]).all.order("id desc").page(params[:page])
    @batches = Batch.all
    @subjects = Subject.all
    respond_to do |format|
      format.html
      format.json {render json: {success: true, html: render_to_string(:partial => "jkci_class.html.erb", :layout => false, locals: {jkci_classes: @jkci_classes}), pagination_html:  render_to_string(partial: 'pagination.html.erb', layout: false, locals: {jkci_classes: @jkci_classes}), css_holder: ".jkciClassTable tbody"}}
    end
  end
  
  def new
    @jkci_class = JkciClass.new
    @teachers = Teacher.all
    @batches = Batch.all
    @subjects = Subject.all
  end

  def show
    @jkci_class = JkciClass.where(id: params[:id]).first
    @chapters = @jkci_class.subject.chapters
    @daily_teaching_points = @jkci_class.daily_teaching_points.includes(:class_catlogs).chapters_points.order('id desc').page(params[:page])
    @teached_chapters = @daily_teaching_points.map(&:chapter_id).uniq
    @class_exams = @jkci_class.jk_exams.order("id desc").page(params[:page])
  end

  def create
    params.permit!
    @jkci_class = JkciClass.new(params[:jkci_class])
    if @jkci_class.save
      redirect_to jkci_classes_path
    end
  end

  def edit
    @jkci_class = JkciClass.where(id: params[:id]).first
    @teachers = Teacher.all
    @batches = Batch.all
    @subjects = Subject.all
  end

  def assign_students
    @jkci_class = JkciClass.where(id: params[:id]).first
    @students = Student.enable_students
    @selected_students = @jkci_class.students.map(&:id)
  end

  def manage_students
    jkci_class = JkciClass.where(id: params[:id]).first
    sutdents = params[:students_ids].map(&:to_i)  rescue []
    jkci_class.manage_students(sutdents) if jkci_class
    render json: {success: true, id: jkci_class.id}
  end
  
  def update
    params.permit!
    jkci_class = JkciClass.where(id: params[:id]).first
    if jkci_class
      if jkci_class.update(params[:jkci_class])
        redirect_to jkci_classes_path
      end
    end
  end
  
  def destroy
    jkci_class = JkciClass.where(id: params[:id]).first
    if jkci_class.destroy
      redirect_to jkci_classes_path
    end
  end
  
  def filter_class
    jkci_classes = JkciClass.includes([:batch]).all.order("id desc").page(params[:page])
    if params[:batch_id].present?
      jkci_classes = jkci_classes.where(batch_id: params[:batch_id])
    end
    if params[:subject_id].present?
      jkci_classes = jkci_classes.where(subject_id: params[:subject_id])
    end
    
    render json: {success: true, html: render_to_string(:partial => "jkci_class.html.erb", :layout => false, locals: {jkci_classes: jkci_classes}), pagination_html:  render_to_string(partial: 'pagination.html.erb', layout: false, locals: {jkci_classes: jkci_classes}), css_holder: ".jkciClassTable tbody"}
  end


  def class_daily_teaches
    jkci_class = JkciClass.includes([:daily_teaching_points, :class_catlogs]).where(id: params[:id]).first
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
    @jkci_class = JkciClass.where(id: params[:id]).first
    @class_exams = @jkci_class.jk_exams.order("id desc").page(params[:page])
    respond_to do |format|
      format.html
      format.json {render json: {success: true, html: render_to_string(:partial => "/exams/exam.html.erb", :layout => false, locals: {exams: @class_exams, hide_edit: true}), pagination_html:  render_to_string(partial: 'exam_pagination.html.erb', layout: false, locals: {class_exams: @class_exams}), css_holder: ".examsTable tbody"}}
    end
  end

  def filter_daily_teach
    @jkci_class = JkciClass.where(id: params[:id]).first
    @daily_teaching_points = @jkci_class.daily_teaching_points.includes(:class_catlogs).chapters_points.order('id desc')
    if params[:chapters].present?
      @daily_teaching_points = @daily_teaching_points.where(chapter_id: params[:chapters].split(',').map(&:to_i))
    end
    @daily_teaching_points = @daily_teaching_points.page(params[:page])
    respond_to do |format|
      format.html
      format.json {render json: {success: true, html: render_to_string(:partial => "daily_teaching_point.html.erb", :layout => false, locals: {daily_teaching_points: @daily_teaching_points, hide_edit: true}), pagination_html:  render_to_string(partial: 'daily_teach_pagination.html.erb', layout: false, locals: {class_daily_teach: @daily_teaching_points}), css_holder: ".dailyTeach"}}
    end
  end

  def my_sanitizer
    #params.permit!
    params.require(:jkci_class).permit!
  end
end
