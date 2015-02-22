class ParentDeskController < ApplicationController
  load_and_authorize_resource :class => false, :class => "Student"
  before_action :authenticate_user!, only: [:parent_desk]

  def parent_desk
    authorize! :roll, :parent
    @students = Student.where(id: current_user.student_id.to_s.split(','))
    @class_catlogs = @students.first.learned_point.first(10)    if @student.count == 1
  end

  def student_info
    if current_user.student_id.to_s.split(',').include?(params[:id])
      @student = Student.where(id: params[:id]).first
      @class_catlogs = @student.learned_point.first(10)
    else
      raise ActionController::RoutingError.new('Not Found')
    end
  end
end
