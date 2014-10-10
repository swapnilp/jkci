class StudentsController < ApplicationController
  def index
    @students = Student.all.order("id desc").paginate(:page => params[:page])
  end

  def new
    @student = Student.new
  end
  
  def create
     params.permit!
    student = Student.new(params[:student])
    if student.save
      redirect_to students_path
    end
  end
  
  def show
    @student = Student.where(id: params[:id]).first
    @exam_catlogs = @student.exam_catlogs.includes([:exam])
    @class_catlogs = @student.class_catlogs.includes([:jkci_class, :daily_teaching_point])
  end
  
  def edit
    @student = Student.where(id: params[:id]).first
    
  end

  def update
    params.permit!
    @student = Student.where(id: params[:id]).first
    if @student && @student.update(params[:student])
      redirect_to students_path
    end
  end

  def destroy
  end


end
