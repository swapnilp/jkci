class ParentDeskController < ApplicationController
  #load_and_authorize_resource :class => false, :class => "Student"
  before_action :authenticate_user!, only: [:parent_desk]

  def parent_desk
    authorize! :roll, :parent
    @students = Student.where(id: current_user.student_id.to_s.split(','))
    @class_catlogs = @students.first.learned_point.first(10)    if @students.count == 1
    @exam_catlogs =  @students.first.class_exams.first(10) if @students.count == 1
    @jkci_classes = @students.first.jkci_classes.select([:class_name, :id]) if @students.count == 1
  end

  def student_info
    authorize! :roll, :parent
    if current_user.student_id.to_s.split(',').include?(params[:id])
      @student = Student.where(id: params[:id]).first
      @class_catlogs = @student.learned_point.page(params[:page])
      @exam_catlogs =  @student.class_exams.page(params[:page])
      @jkci_classes = @student.jkci_classes.select([:class_name, :id])
    else
      raise ActionController::RoutingError.new('Not Found')
    end
  end

  def paginate_class_catlog
  end

  def paginate_exam_catlog
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
