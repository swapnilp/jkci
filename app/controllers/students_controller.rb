class StudentsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource param_method: :my_sanitizer

  def index
    @students = Student.all.order("id desc").page(params[:page])
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

  private
  
  def my_sanitizer
    #params.permit!
    params.require(:student).permit!
  end

end
