class JkciClassesController < ApplicationController
  before_action :authenticate_user!
  def index
    @jkci_classes = JkciClass.includes([:batch]).all.order("id desc").paginate(:page => params[:page])
    @batches = Batch.all
    @subjects = Subject.all
  end
  
  def new
    @jkci_class = JkciClass.new
    @teachers = Teacher.all
    @batches = Batch.all
    @subjects = Subject.all
  end

  def show
    @jkci_class = JkciClass.where(id: params[:id]).first
  end


  def create
    params.permit!
    @jkci_class = JkciClass.new(params[:jkci_class])
    if @jkci_class.save
      redirect_to jkci_classes_path
    end
  end

  def edit
    @jkci_class = JkciClass.where(id: params[:id]).first
    @teachers = Teacher.all
    @batches = Batch.all
    @subjects = Subject.all
  end

  def assign_students
    @jkci_class = JkciClass.where(id: params[:id]).first
    @students = Student.all
    @selected_students = @jkci_class.students.map(&:id)
  end

  def manage_students
    jkci_class = JkciClass.where(id: params[:id]).first
    sutdents = params[:students_ids].map(&:to_i)  rescue []
    jkci_class.manage_students(sutdents) if jkci_class
    render json: {success: true, id: jkci_class.id}
  end
  
  def update
    params.permit!
    jkci_class = JkciClass.where(id: params[:id]).first
    if jkci_class
      if jkci_class.update(params[:jkci_class])
        redirect_to jkci_classes_path
      end
    end
  end
  
  def destroy
    jkci_class = JkciClass.where(id: params[:id]).first
    if jkci_class.destroy
      redirect_to jkci_classes_path
    end
  end
  
  def filter_class
    jkci_classes = JkciClass.all
    if params[:batch_id].present?
      jkci_classes = jkci_classes.where(batch_id: params[:batch_id])
    end
    if params[:subject_id].present?
      jkci_classes = jkci_classes.where(subject_id: params[:subject_id])
    end
    render json: {success: true, html: render_to_string(:partial => "jkci_class.html.erb", :layout => false, locals: {jkci_classes: jkci_classes})}
  end
end
