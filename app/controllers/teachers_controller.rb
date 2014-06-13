class TeachersController < ApplicationController
  def index
    @teachers = Teacher.all
  end
  
  def new
    @teacher = Teacher.new
  end

  def create
    params.permit!
    @teacher = Teacher.new(params[:teacher])
    if @teacher.save
      redirect_to teachers_path
    end
  end

  def edit
    @teacher = Teacher.where(id: params[:id]).first
  end
  
  def update
    params.permit!
    teacher = Teacher.where(id: params[:id]).first
    p teacher
    if teacher
      if teacher.update(params[:teacher])
        redirect_to teachers_path
      end
    end
  end
  
  def destroy
    teacher = Teacher.where(id: params[:id]).first
    if teacher.destroy
      redirect_to teachers_path
    end
  end
end
