class StudentsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource param_method: :my_sanitizer

  def index
    @students = @organisation.students.select([:id, :first_name, :last_name, :std, :group, :mobile, :p_mobile, :enable_sms, :gender, :is_disabled]).order("id desc").page(params[:page])
    @batches = Batch.active
    respond_to do |format|
      format.html
      format.json {render json: {success: true, html: render_to_string(:partial => "student.html.erb", :layout => false, locals: {students: @students}), pagination_html: render_to_string(partial: 'pagination.html.erb', layout: false, locals: {students: @students}), css_holder: ".studentsTable tbody"}}
    end
  end

  def new
    @student = @organisation.students.build
    @batches = Batch.active
    @standards = @organisation.standards.active
    @subjects = @standards.first.try(:subjects).try(:optional) || []
  end
  
  def create
    params.permit!
    @student = @organisation.students.build(params[:student])
    if @student.save
      @student.add_students_subjects(params[:o_subjects])
      redirect_to students_path
    else
      @batches = Batch.active
      @standards = @organisation.standards.active
      @subjects = @standards.first.try(:subjects).try(:optional) || []
      render :new
    end
  end
  
  def show
    @student = @organisation.students.where(id: params[:id]).first
    
    @exam_catlogs = @student.exam_catlogs.includes([:exam]).order('id desc').page(params[:page])
    @class_catlogs = @student.class_catlogs.includes([:jkci_class, :daily_teaching_point]).order('id desc').page(params[:page])
  end

  def filter_students_data
    authorize! :roll, :clark
    student = @organisation.students.where(id: params[:id]).first
    includes_tables = params[:data_type] == 'exam' ? [:exam] : [:jkci_class, :daily_teaching_point]
    catlogs = student.send("#{params[:data_type].singularize}_catlogs".to_sym).includes(includes_tables).order('id desc').page(params[:page])
    respond_to do |format|
      format.html
      format.json {render json: {success: true, html: render_to_string(:partial => "students_#{params[:data_type]}.html.erb", :layout => false, locals: {catlogs: catlogs}), pagination_html: render_to_string(partial: 'filter_pagination.html.erb', layout: false, locals: {catlogs: catlogs,  params: {data_type: params[:data_type]}}), css_holder: ".#{params[:data_type]}Table tbody"}}
    end
  end
  
  def edit
    @student = @organisation.students.where(id: params[:id]).first
    @batches = Batch.active
    @standards = @organisation.standards.active
    @subjects = (@student.standard.try(:subjects) || @standards.first.try(:subjects)).try(:optional) || []
  end

  def update
    params.permit!
    @student = @organisation.students.where(id: params[:id]).first
    if @student && @student.update(params[:student])
      @student.add_students_subjects(params[:o_subjects])
      redirect_to students_path
    end
  end

  def destroy
  end

  def download_report
    @student = @organisation.students.where(id: params[:id]).first
    @exam_catlogs = @student.exam_table_format
    @dtps = @student.class_catlogs.absent
    filename = "#{@student.name}.xls"
    respond_to do |format|
      format.xls { headers["Content-Disposition"] = "attachment; filename=\"#{filename}\"" }
      format.pdf { render :layout => false }
    end
  end
  
  def enable_sms
    student = @organisation.students.select([:id, :enable_sms, ]).where(id: params[:id]).first
    student.activate_sms
    render json: {success: true}
  end

  def filter_students
    students = @organisation.students.select([:id, :first_name, :last_name, :std, :group, :mobile, :p_mobile, :enable_sms, :batch_id, :gender, :is_disabled])
    if params[:batch_id].present?
      students = students.where(batch_id: params[:batch_id])
    end

    if params[:filter].present?
      students = students.where("first_name like ? OR last_name like ? OR mobile like ? OR p_mobile like ?", "%#{params[:filter]}%", "%#{params[:filter]}%", "%#{params[:filter]}%", "%#{params[:filter]}%")
    end

    if params[:gender].present?
      students = students.where(gender: params[:gender])
    end
    
    students = students.order("id desc").page(params[:page])
    pagination_html = render_to_string(partial: 'pagination.html.erb', layout: false, locals: {students: students})

    render json: {success: true, html: render_to_string(:partial => "student.html.erb", :layout => false, locals: {students: students}), pagination_html:  pagination_html, css_holder: ".studentsTable tbody"}
  end

  def select_user
    users = User.where(role: 'parent')
    render json: {success: true, html: render_to_string(:partial => "user.html.erb", :layout => false, locals: {users: users})}
  end
  
  def disable_student
    student = @organisation.students.where(id: params[:id]).first
    if student
      student.update_attributes({is_disabled: true, enable_sms: false})
      student.jkci_classes.clear
      redirect_to student_path(student)
    else
      redirect_to students_path
    end
  end

  

  private
  
  def my_sanitizer
    #params.permit!
    params.require(:student).permit!
  end

end
