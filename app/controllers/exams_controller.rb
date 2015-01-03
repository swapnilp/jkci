class ExamsController < ApplicationController
  before_action :authenticate_user!
  def index
    @exams = Exam.all.order("id desc").paginate(:page => params[:page])
    @jkci_classes = JkciClass.all
  end
  
  def new
    if params[:jkci_class_id].present?
      @exam = Exam.new({jkci_class_id: params[:jkci_class_id], daily_teaching_points: ",#{params[:dtp]},"})
    else
      @exam = Exam.new
    end
    @subjects = Subject.all
    @jkci_classes = JkciClass.all
  end

  def show
    @exam = Exam.where(id: params[:id]).first
    @remaining_students = @exam.exam_catlogs.includes([:student]).where("is_present is ? || (is_recover =  true && marks is ?)", nil, nil)
    @exam_absents = @exam.exam_catlogs.includes([:student, :exam]).where(is_present: false)
  end

  def create
    params.permit!
    params[:exam][:class_ids] = (params[:exam][:class_ids].present? && params[:exam][:class_ids].last.present?) ? ","+params[:exam][:class_ids].reject(&:blank?).map(&:to_i).join(',') + ','  : nil
    exam = Exam.new(params[:exam])
    if exam.save
      redirect_to exams_path
    end
  end

  def edit
    @subjects = Subject.all
    @exam = Exam.where(id: params[:id]).first
    @jkci_classes = JkciClass.all
  end
  
  def update
    params.permit!
    params[:exam][:class_ids] =  (params[:exam][:class_ids].present? && params[:exam][:class_ids].last.present?) ? ","+params[:exam][:class_ids].reject(&:blank?).map(&:to_i).join(',') + ','  : nil
    exam = Exam.where(id: params[:id]).first
    if exam && exam.update(params[:exam])
      redirect_to exams_path
    end
  end

  def destroy
  end

  def absunts_students
    @exam = Exam.where(id: params[:id]).first
    #ids = [0] << @exam.exam_absents.map(&:student_id) 
    #ids << @exam.exam_results.map(&:student_id)
    @students = @exam.students.where("exam_catlogs.is_present is ?", nil)
  end

  def remove_exam_absent
    exam_catlog = ExamCatlog.where(exam_id: params[:id], student_id: params[:student_id]).first
    exam_catlog.update_attributes({is_present: nil, is_recover: nil})
    redirect_to exam_path(params[:id])
  end

  def add_absunt_students
    @exam = Exam.where(id: params[:id]).first
    @exam.add_absunt_students(params[:students_ids].keys)
    redirect_to exam_path(@exam)
  end

  def recover_exam
    #@exam = Exam.where(id: params[:id]).first
    exam_catlog = ExamCatlog.where(id: params[:exam_catlog_id]).first
    exam_catlog.update_attributes({is_recover: true, recover_date: Date.today})
    redirect_to exam_path(params[:id])
  end

  def exams_students
    @exam = Exam.where(id: params[:id]).first
    @absent_students = @exam.absent_students
    @students = @exam.students.where("(exam_catlogs.is_present is ? && exam_catlogs.marks is ? ) || (exam_catlogs.is_present = ? && exam_catlogs.marks is ? && exam_catlogs.is_recover = ?)", nil, nil, false, nil, true)
  end

  def add_exam_results
    @exam = Exam.where(id: params[:id]).first
    @exam.add_exam_results(params[:students_results])
    redirect_to exam_path(@exam)
  end

  def remove_exam_result
    ExamCatlog.where(id: params[:exam_catlog_id]).first.update_attributes({marks: nil, is_present: false})
    redirect_to exam_path(params[:id])
  end


  def publish_exam_result
    @exam = Exam.where(id: params[:id]).first
    if @exam
      @exam.publish_results
      @exam.update({is_result_decleared: true, is_completed: true})
    end
    redirect_to exams_path
  end
  
  def exam_completed
    @exam = Exam.where(id: params[:id]).first
    if @exam
      @exam.complete_exam
    end
    redirect_to exam_path(@exam)
  end
  
  def filter_exam
    exams = params[:class_id].present? ? Exam.where("jkci_class_id = ? OR class_ids like ?", params[:class_id], "%,#{params[:class_id]},%") : Exam.all
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
    render json: {success: true, html: render_to_string(:partial => "exam.html.erb", :layout => false, locals: {exams: exams})}
  end

  def follow_exam_absent_student
    exam_catlog = ExamCatlog.where(id: params[:exam_catlog_id]).first
    exam_catlog.update_attributes({is_followed: true}) if exam_catlog
    render json: {success: true}
  end

end
