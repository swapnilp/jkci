class ExamAbsentsController < ApplicationController
  before_action :authenticate_user!
  def destroy
    exam_absent = ExamAbsent.where(id: params[:id]).first
    exam = exam_absent.exam
    exam_absent.destroy
    redirect_to exam_path(exam)
  end
end
