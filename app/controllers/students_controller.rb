class StudentsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource param_method: :my_sanitizer

  def index
    @students = Student.select([:id, :first_name, :last_name, :std, :group, :mobile, :p_mobile, :enable_sms]).order("id desc").page(params[:page])
    @batches = Batch.active
    respond_to do |format|
      format.html
      format.json {render json: {success: true, html: render_to_string(:partial => "student.html.erb", :layout => false, locals: {students: @students}), pagination_html: render_to_string(partial: 'pagination.html.erb', layout: false, locals: {students: @students}), css_holder: ".studentsTable tbody"}}
    end
  end

  def new
    @student = Student.new
    @batches = Batch.active
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
    @batches = Batch.active
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
  
  def enable_sms
  end

  def filter_students
    students = Student.select([:id, :first_name, :last_name, :std, :group, :mobile, :p_mobile, :enable_sms, :batch_id])
    if params[:batch_id].present?
      students = students.where(batch_id: params[:batch_id])
    end

    if params[:filter].present?
      students = students.where("first_name like ? OR last_name like ? OR mobile like ? OR p_mobile like ?", "%#{params[:filter]}%", "%#{params[:filter]}%", "%#{params[:filter]}%", "%#{params[:filter]}%")
    end
    
    students = students.order("id desc").page(params[:page])
    pagination_html = render_to_string(partial: 'pagination.html.erb', layout: false, locals: {students: students})

    render json: {success: true, html: render_to_string(:partial => "student.html.erb", :layout => false, locals: {students: students}), pagination_html:  pagination_html, css_holder: ".studentsTable tbody"}
  end

  def select_user
    users = User.where(role: 'parent')
    render json: {success: true, html: render_to_string(:partial => "user.html.erb", :layout => false, locals: {users: users})}
  end

  private
  
  def my_sanitizer
    #params.permit!
    params.require(:student).permit!
  end

end
