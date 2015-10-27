class ExamsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource param_method: :my_sanitizer
  include ExamsHelper


  def index
    @exams = @organisation.exams.all.order("id desc").page(params[:page])
    @jkci_classes = @organisation.jkci_classes.all
    respond_to do |format|
      format.html
      format.json {render json: {success: true, html: render_to_string(:partial => "exam.html.erb", :layout => false, locals: {exams: @exams}), pagination_html:  render_to_string(partial: 'pagination.html.erb', layout: false, locals: {exams: @exams}), css_holder: ".examsTable tbody"}}
    end
  end
  
  def new
    @jkci_class = @organisation.jkci_classes.where(id: params[:jkci_class_id]).first
    @exam = @jkci_class.exams.build({daily_teaching_points: ",#{params[:dtp]},"})
    @sub_classes = @jkci_class.sub_classes.select([:id, :name, :jkci_class_id])
    @exam.name = @exam.predict_name
    @subjects = @jkci_class.standard.subjects
  end

  def show
    @exam = @organisation.exams.where(id: params[:id]).first
    @remaining_students = @exam.exam_catlogs.includes([:student]).where(is_present: [nil], marks: nil, is_ingored: [nil, false])
    @exam_absents = @exam.exam_catlogs.includes([:student, :exam]).where(is_present: false)
    @ignored_students = @exam.exam_catlogs.includes([:student, :exam]).where(is_ingored: true)
    @pending_notifications = @exam.notifications.pending
  end
  
  def download_data
    @exam = @organisation.exams.where(id: params[:id]).first
    @exam_catlogs = @exam.exam_table_format
    filename = "#{@exam.name}.xls"
    respond_to do |format|
      format.xls { headers["Content-Disposition"] = "attachment; filename=\"#{filename}\"" }
      format.pdf { render :layout => false }
    end
  end

  def create
    params.permit!
    params[:exam][:class_ids] = (params[:exam][:class_ids].present? && params[:exam][:class_ids].last.present?) ? ","+params[:exam][:class_ids].reject(&:blank?).map(&:to_i).join(',') + ','  : nil
    params[:exam][:sub_classes] = (params[:exam][:sub_classes].map(&:to_i) - [0]).join(',') if params[:exam][:sub_classes].present? 
    @exam = @organisation.exams.build(params[:exam])
    if @exam.save
      Notification.add_create_exam(@exam.id, @organisation)
      redirect_to exams_path
    else
      @jkci_class = @organisation.jkci_classes.where(id: params[:jkci_class_id]).first
      @sub_classes = @jkci_class.sub_classes.select([:id, :name, :jkci_class_id])
      @subjects = @jkci_class.standard.subjects
      render :new
    end
  end

  def edit
    @jkci_class = @organisation.jkci_classes.where(id: params[:jkci_class_id]).first
    @exam = @jkci_class.exams.where(id: params[:id]).first
    @sub_classes = @jkci_class.sub_classes.select([:id, :name, :jkci_class_id])
    @subjects = @jkci_class.standard.subjects
    redirect_to exams_path if @exam.is_completed
  end
  
  def update
    params.permit!
    params[:exam][:class_ids] =  (params[:exam][:class_ids].present? && params[:exam][:class_ids].last.present?) ? ","+params[:exam][:class_ids].reject(&:blank?).map(&:to_i).join(',') + ','  : nil
    params[:exam][:sub_classes] = (params[:exam][:sub_classes].map(&:to_i) - [0]).join(',') if params[:exam][:sub_classes].present? 
    exam = @organisation.exams.where(id: params[:id]).first
    if exam && exam.update(params[:exam])
      redirect_to exams_path
    else
      @jkci_class = @organisation.jkci_classes.where(id: params[:jkci_class_id]).first
      @sub_classes = @jkci_class.sub_classes.select([:id, :name, :jkci_class_id])
      @subjects = @jkci_class.standard.subjects
      render :edit
    end
  end

  def destroy
    jkci_class = @organisation.jkci_classes.where(id: params[:jkci_class_id]).first
    exam = jkci_class.exams.where(id: params[:id]).first
    exam.update_attributes({is_active: false})
    redirect_to exams_path
  end

  def verify_create_exam
    exam = @organisation.exams.where(id: params[:id]).first
    if exam
      exam.update_attributes({create_verification: true})
      Notification.verified_exam(exam.id, @organisation)
    end
    redirect_to exam_path(exam)
  end
  
  def verify_exam_absenty
    exam = @organisation.exams.where(id: params[:id]).first
    if exam
      exam.update_attributes({verify_absenty: true})
      Notification.verify_exam_abesnty(exam.id, @organisation)
    end
    redirect_to exam_path(exam)
  end
  
  def verify_exam_result
    exam = @organisation.exams.where(id: params[:id]).first
    if exam
      exam.verify_exam_result
    end
    redirect_to exam_path(exam)
  end

  def absunts_students
    @exam = @organisation.exams.where(id: params[:id]).first
    #ids = [0] << @exam.exam_absents.map(&:student_id) 
    #ids << @exam.exam_results.map(&:student_id)
    students_ids = @exam.exam_catlogs.where(is_present: nil, is_ingored: [nil, false]).map(&:student_id)
    @students = @exam.students.where(id: students_ids)
  end

  def remove_exam_absent
    exam = @organisation.exams.where(id: params[:id]).first
    exam.remove_absent_student(params[:student_id])
    redirect_to exam_path(params[:id])
  end

  def add_absunt_students
    @exam = @organisation.exams.where(id: params[:id]).first
    if @exam.create_verification && params[:students_ids].present?
      @exam.add_absunt_students(params[:students_ids].keys)
    end
    redirect_to exam_path(@exam)
  end

  def recover_exam
    #@exam = Exam.where(id: params[:id]).first
    exam_catlog = @organisation.exam_catlogs.where(id: params[:exam_catlog_id]).first
    exam_catlog.update_attributes({is_recover: true, recover_date: Date.today})
    redirect_to exam_path(params[:id])
  end

  def exams_students
    @exam = @organisation.exams.where(id: params[:id]).first
    @absent_students = @exam.absent_students
    @students = @exam.students.where("(exam_catlogs.is_present is ? && exam_catlogs.marks is ? && exam_catlogs.is_ingored is ?) || (exam_catlogs.is_present = ? && exam_catlogs.marks is ? && exam_catlogs.is_recover = ? && exam_catlogs.is_ingored is ?)", nil, nil, nil, false, nil, true, nil)
  end

  def add_exam_results
    @exam = @organisation.exams.where(id: params[:id]).first
    if @exam.create_verification && params[:students_results].present?
      @exam.add_exam_results(params[:students_results])
    end
    redirect_to exam_path(@exam)
  end

  def remove_exam_result
    exam = @organisation.exams.where(id: params[:id]).first
    exam.remove_exam_result(params[:exam_catlog_id])
    redirect_to exam_path(exam)
  end


  def publish_exam_result
    @exam = @organisation.exams.where(id: params[:id]).first
    if @exam && @exam.verify_absenty && @exam.verify_result
      @exam.publish_results
    end
    redirect_to exams_path
  end

  def publish_absent_exam
    @exam = @organisation.exams.where(id: params[:id]).first
    if @exam && @exam.verify_absenty
      @exam.publish_absentee
    end
    redirect_to exam_path(@exam)
  end
  
  def exam_completed
    @exam = @organisation.exams.where(id: params[:id]).first
    if @exam && @exam.create_verification
      @exam.complete_exam unless @exam.is_completed
    end
    redirect_to exam_path(@exam)
  end
  
  def filter_exam
    exams = params[:class_id].present? ? @organisation.exams.where("jkci_class_id = ? OR class_ids like ?", params[:class_id], "%,#{params[:class_id]},%") : @organisation.exams
    if params[:type].present?
      exams = exams.where(exam_type: params[:type])
    end
    if params[:status].present?
      if params[:status] == "Created"
        exams = exams.where(is_completed: [nil, false])
      elsif params[:status] == "Conducted"
        exams = exams.where(is_completed: true, is_result_decleared: [nil, false])
      elsif params[:status] == "Published"
        exams = exams.where(is_result_decleared: true)
      end
    end
    exams = exams.order("id desc").page(params[:page]).per(10);
    pagination_html = render_to_string(partial: 'pagination.html.erb', layout: false, locals: {exams: exams})
    render json: {success: true, count: exams.total_count, html: render_to_string(:partial => "exam.html.erb", :layout => false, locals: {exams: exams}), pagination_html:  pagination_html, css_holder: ".examsTable tbody"}
  end

  def download_exams_report
    exams = params[:class_id].present? ? @organisation.exams.where("jkci_class_id = ? OR class_ids like ?", params[:class_id], "%,#{params[:class_id]},%") : @organisation.exams
    if params[:type].present?
      exams = exams.where(exam_type: params[:type])
    end
    if params[:status].present?
      if params[:status] == "Created"
        exams = exams.where(is_completed: [nil, false])
      elsif params[:status] == "Conducted"
        exams = exams.where(is_completed: true, is_result_decleared: [nil, false])
      elsif params[:status] == "Published"
        exams = exams.where(is_result_decleared: true)
      end
    end

    if params[:class_id].present?
      @jkci_class = @organisation.jkci_classes.where(id: params[:class_id]).first
    end

    @exams_count = exams.count
    @exams_table_format = exams_table_format(exams)

    respond_to do |format|
      format.pdf { render :layout => false }
    end
  end

  def follow_exam_absent_student
    exam_catlog = @organisation.exam_catlogs.where(id: params[:exam_catlog_id]).first
    exam_catlog.update_attributes({is_followed: true}) if exam_catlog
    render json: {success: true}
  end

  def upload_paper
    params.permit!
    attachment = @organisation.documents.build(params[:document])
    attachment.exam_id= params[:exam_id]
    if attachment.save     
      respond_to do |format|
        format.json {render json: {success: true, id: attachment.id, url: attachment.document.url, name: attachment.document_file_name}}
      end
    else
      Rails.logger.info attachment.errors.inspect
      respond_to do |format|
        format.json {render json: {success: false, msg: attachment.errors.messages.values.first.first}}
      end
    end
  end

  def ignore_student
    exam = @organisation.exams.where(id: params[:id]).first
    if exam 
      exam.add_ignore_student(params[:student_id])
    end
    redirect_to exam_path(exam)
  end
  
  def remove_ignore_student
    exam = @organisation.exams.where(id: params[:id]).first
    if exam 
      exam.remove_ignore_student(params[:student_id])
    end
    redirect_to exam_path(exam)
  end

  private
  
  def my_sanitizer
    #params.permit!
    params.require(:exam).permit!
  end

end
