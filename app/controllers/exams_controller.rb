class ExamsController < ApplicationController

  def index
    @exams = Exam.all
  end
  
  def new
    @exam = Exam.new
  end

  def show
    @exam = Exam.where(id: params[:id]).first
  end

  def create
    params.permit!
    exam = Exam.new(params[:exam])
    if exam.save
      redirect_to exams_path
    end
  end

  def edit
    @exam = Exam.where(id: params[:id]).first
  end
  
  def update
    params.permit!
    exam = Exam.where(id: params[:id]).first
    if exam && exam.update(params[:exam])
      redirect_to exams_path
    end
  end

  def destroy
  end

  def absunts_students
    @exam = Exam.where(id: params[:id]).first
    ids = [0] << @exam.exam_absents.map(&:student_id) 
    ids << @exam.exam_results.map(&:student_id)
    @students = @exam.students.where('id not in (?)', ids.flatten)
  end

  def add_absunt_students
    @exam = Exam.where(id: params[:id]).first
    @exam.add_absunt_students(params[:students_ids].keys)
    redirect_to exam_path(@exam)
  end

  def add_reattend_absent_exam
    #@exam = Exam.where(id: params[:id]).first
  end

  def exams_students
    @exam = Exam.where(id: params[:id]).first
    ids = [0] << @exam.exam_absents.map(&:student_id) 
    ids << @exam.exam_results.map(&:student_id)
    @students = @exam.students.where('id not in (?)', ids.flatten)
  end

  def add_exam_results
    @exam = Exam.where(id: params[:id]).first
    @exam.add_exam_results(params[:students_results])
    redirect_to exam_path(@exam)
  end
end
