class DailyTeachsController < ApplicationController
  
  def index
    @daily_teaching_points = DailyTeachingPoint.all
  end
  
  def new
    if params[:jkci_class_id].present?
      jkci_class = JkciClass.where(id: params[:jkci_class_id]).first
      @daily_teaching_point = jkci_class.daily_teaching_points.new({teacher_id: jkci_class.teacher_id})
    else
      @daily_teaching_point = DailyTeachingPoint.new
    end
    @jkci_classes = JkciClass.all
    @teachers = Teacher.all
  end

  def create
    params.permit!
    @daily_teaching_point = DailyTeachingPoint.new(params[:daily_teaching_point])
    if @daily_teaching_point.save
      redirect_to daily_teach_path(@daily_teaching_point)
    else
      render :new
    end
  end

  def show
    @daily_teaching_point = DailyTeachingPoint.where(id: params[:id]).first
  end
  
  def edit
    
  end

  def update
  end
end
