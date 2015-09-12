class DailyTeachsController < ApplicationController
  before_action :authenticate_user!  
  load_and_authorize_resource class: 'DailyTeachingPoint', param_method: :my_sanitizer

  def index
    @daily_teaching_points = DailyTeachingPoint.all.page(params[:page])
    @jkci_classes = JkciClass.all
    @teachers = Teacher.all
    respond_to do |format|
      format.html
      format.json {render json: {success: true, html: render_to_string(:partial => "daily_teach.html.erb", :layout => false, locals: {daily_teaching_points: @daily_teaching_points}), pagination_html:  render_to_string(partial: 'pagination.html.erb', layout: false, locals: {daily_teaching_points: @daily_teaching_points}), css_holder: ".dailyTeachTable tbody"}}
    end
  end
  
  def new
    if params[:jkci_class_id].present?
      @jkci_class = JkciClass.where(id: params[:jkci_class_id]).first
      @daily_teaching_point = @jkci_class.daily_teaching_points.new({teacher_id: @jkci_class.teacher_id, chapter_id: @jkci_class.current_chapter_id})
      @chapters = @jkci_class.try(:subject).try(:chapters)
      @chapters_points = @jkci_class.current_chapter_id.present? ? @jkci_class.current_chapter.chapters_points : @chapters.first.try(:chapters_points)
    else
      @daily_teaching_point = DailyTeachingPoint.new
      @chapters = Chapter.all
    end
    @jkci_classes = JkciClass.all
    @teachers = Teacher.all
  end

  def create
    params.permit!
    @daily_teaching_point = DailyTeachingPoint.new(params[:daily_teaching_point])
    if @daily_teaching_point.save
      @daily_teaching_point.create_catlog
      redirect_to daily_teach_path(@daily_teaching_point)
    else
      render :new
    end
  end

  def show
    @daily_teaching_point = DailyTeachingPoint.where(id: params[:id]).first
    @class_catlogs = @daily_teaching_point.class_catlogs.includes([:student, :jkci_class])
    #@students = @daily_teaching_point.jkci_class.students
    #@present_students = @daily_teaching_point.class_catlogs.where(is_present: true).map(&:student_id)
    #@absent_students = @daily_teaching_point.class_catlogs.where(is_present: false).collect{|cc| {cc.student_id =>  cc.sms_sent}}.reduce(Hash.new, :merge)
    @exams = @daily_teaching_point.exams
  end
  
  def edit
    @daily_teaching_point = DailyTeachingPoint.where(id: params[:id]).first
    @jkci_classes = JkciClass.all
    @teachers = Teacher.all
    @chapters = @daily_teaching_point.jkci_class.subject.chapters
    @chapters_points = @daily_teaching_point.chapter.try(:chapters_points)
  end

  def update
    params.permit!
    @daily_teaching_point = DailyTeachingPoint.where(id: params[:id]).first
    @daily_teaching_point.update_attributes(params[:daily_teaching_point])
    redirect_to daily_teach_path(@daily_teaching_point)
  end

  def get_class_students
    @daily_teaching_point = DailyTeachingPoint.where(id: params[:id]).first
    @students = @daily_teaching_point.jkci_class.students
    @present_students = @daily_teaching_point.class_catlogs.map(&:student_id)
    render json: {html: render_to_string(:partial => "student_catlog.html.erb", :layout => false)}
  end
  
  def class_presenty
    present_students = params[:students]
    jkci_class = JkciClass.where(id: params[:id]).first
  end
  

  def fill_catlog
    @daily_teaching_point = DailyTeachingPoint.where(id: params[:id]).first
    @daily_teaching_point.fill_catlog(params[:students_list].split(','), params[:date])
    #@daily_teaching_point.publish_absenty
    redirect_to jkci_class_path(@daily_teaching_point.jkci_class)
  end
  
  def filter_teach
    daily_teaching_points = DailyTeachingPoint.all.page(params[:page])
    if params[:class_id].present?
      daily_teaching_points = daily_teaching_points.where(jkci_class_id: params[:class_id])
    end
    if params[:teacher].present?
      daily_teaching_points = daily_teaching_points.where(teacher_id: params[:teacher])
    end
    render json: {success: true, html: render_to_string(:partial => "daily_teach.html.erb", :layout => false, locals: {daily_teaching_points: daily_teaching_points}), pagination_html:  render_to_string(partial: 'pagination.html.erb', layout: false, locals: {daily_teaching_points: daily_teaching_points}), css_holder: ".dailyTeachTable tbody"}
  end

  
  def follow_teach
    class_catlog = ClassCatlog.where(id: params[:id]).first
    class_catlog.update_attributes({is_followed: true}) if class_catlog
    render json: {success: true}
  end

  def recover_daily_teach
    class_catlog = ClassCatlog.where(id: params[:class_catlog_id]).first
    class_catlog.update_attributes({is_recover: true, recover_date: Date.today}) if class_catlog
    render json: {success: true}
  end

  def send_class_absent_sms
    daily_teaching_point = DailyTeachingPoint.where(id: params[:id]).first
    daily_teaching_point.publish_absenty
    redirect_to jkci_class_path daily_teaching_point.jkci_class
  end

  private
  
  def my_sanitizer
    #params.permit!
    params.require(:daily_teaching_point).permit!
  end
  
end
