class SubClassesController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource param_method: :my_sanitizer
  
  def new
    @jkci_class = JkciClass.where(id: params[:jkci_class_id]).first
    if @jkci_class
      @sub_class = @jkci_class.sub_classes.new
    else
      redirect_to jkci_classes_path
    end
  end

  def show
    @jkci_class = JkciClass.where(id: params[:jkci_class_id]).first
    @sub_class = @jkci_class.sub_classes.where(id: params[:id]).first
    @students = @sub_class.students
  end
  
  def create 
    jkci_class = JkciClass.where(id: params[:jkci_class_id]).first
    if jkci_class
      sub_class = jkci_class.sub_classes.new(params[:sub_class].merge({organisation_id: @organisation.id}))
      if sub_class.save
        redirect_to jkci_class_path(jkci_class)
      else
        render :new
      end
    else
      redirect_to jkci_classes_path
    end
  end

  def get_students
    @jkci_class = JkciClass.where(id: params[:jkci_class_id]).first
    sub_class_students = @jkci_class.sub_classes.where(id: params[:id]).first.try(&:students)
    sub_class_students_ids = sub_class_students.map(&:id) || []
    sub_class_students_ids << 0
    @students = @jkci_class.students.select([:id, :first_name, :last_name, :parent_name, :p_mobile]).where("students.id not in (?)", sub_class_students_ids)
    respond_to do |format|
      format.json {render json: {success: true, students: @students}}
    end
  end

  def add_students
    jkci_class = JkciClass.where(id: params[:jkci_class_id]).first
    if jkci_class
      jkci_class.add_sub_class_students(params[:students], params[:id])
      respond_to do |format|
        format.json {render json: {success: true}}
      end
    else
      respond_to do |format|
        format.json {render json: {success: false}}
      end
    end
  end
  
  def remove_students
    jkci_class = JkciClass.where(id: params[:jkci_class_id]).first
    jkci_class.remove_sub_class_students(params[:student], params[:id])
    redirect_to jkci_class_sub_class_path(jkci_class, params[:id])
  end
  
  private
  
  def my_sanitizer
    #params.permit!
    params.require(:sub_class).permit!
  end
end
