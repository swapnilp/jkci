class ExamResultsController < ApplicationController
  
  def destroy
    exam_result = ExamResult.where(id: params[:id]).first
    exam = exam_result.exam
    exam_result.destroy
    redirect_to exam_path(exam)
  end

end
