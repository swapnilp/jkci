class ParentDeskController < ApplicationController
  #load_and_authorize_resource :class => false, :class => "Student"
  before_action :authenticate_user!, only: [:parent_desk]

  def parent_desk
    authorize! :roll, :parent
    @students = Student.where(id: current_user.student_id.to_s.split(','))
    @class_catlogs = @students.first.learned_point.first(10)    if @students.count == 1
    @jkci_classes = @students.first.jkci_classes.select([:class_name, :id]) if @students.count == 1
  end

  def student_info
    authorize! :roll, :parent
    if current_user.student_id.to_s.split(',').include?(params[:id])
      @student = Student.where(id: params[:id]).first
      @class_catlogs = @student.learned_point.page(params[:page])
      @jkci_classes = @student.jkci_classes.select([:class_name, :id])
    else
      raise ActionController::RoutingError.new('Not Found')
    end
  end

  def teached_info 
    student = Student.where(id: params[:id]).first
    class_catlogs = student.learned_point.page(params[:page])
    jkci_classes = student.jkci_classes.select([:class_name, :id])
    render json: {success: true, html: render_to_string(:partial => "teaching_info.html.erb", :layout => false, locals: {class_catlogs: class_catlogs, jkci_classes: jkci_classes})}
  end

  def exam_info
    student = Student.where(id: params[:id]).first
    exam_catlogs =  student.class_exams.page(params[:page])
    jkci_classes = student.jkci_classes.select([:class_name, :id])
    render json: {success: true, html: render_to_string(:partial => "exam_info.html.erb", :layout => false, locals: {exam_catlogs: exam_catlogs, jkci_classes: jkci_classes})}
  end
  
  def paginate_catlog
    student = Student.where(id: params[:id]).first
    if params[:catlog] == 'teached'
      class_catlogs = student.learned_point.page(params[:page])
      render json: {success: true, html: render_to_string(:partial => "class_catlog.html.erb", :layout => false, locals: {class_catlogs: class_catlogs}), pagination_html:  render_to_string(partial: 'pagination.html.erb', layout: false, locals: {class_catlogs: class_catlogs, stream: 'teached'}), css_holder: ".studentLearnTable tbody"}
    else
      exam_catlogs =  student.class_exams.page(params[:page])
      render json: {success: true, html: render_to_string(:partial => "exam_catlog.html.erb", :layout => false, locals: {exam_catlogs: exam_catlogs}), pagination_html:  render_to_string(partial: 'pagination.html.erb', layout: false, locals: {class_catlogs: exam_catlogs, stream: 'exams'}), css_holder: ".studentLearnTable tbody"}
    end
  end
  
  def student_exam_info
    authorize! :roll, :parent
    if current_user.student_id.to_s.split(',').include?(params[:id])
      @student = Student.where(id: params[:id]).first
    else
      raise ActionController::RoutingError.new('Not Found')
    end
  end

end
