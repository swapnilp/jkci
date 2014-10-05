class ExamsController < ApplicationController

  def index
    @exams = Exam.all
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
    @remaining_students = @exam.students - (@exam.absent_students + @exam.present_students)
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
    ids = [0] << @exam.exam_absents.map(&:student_id) 
    ids << @exam.exam_results.map(&:student_id)
    @students = @exam.students.where('students.id not in (?)', ids.flatten)
  end

  def add_absunt_students
    @exam = Exam.where(id: params[:id]).first
    @exam.add_absunt_students(params[:students_ids].keys)
    redirect_to exam_path(@exam)
  end

  def add_reattend_absent_exam
    #@exam = Exam.where(id: params[:id]).first
  end

  def exams_students
    @exam = Exam.where(id: params[:id]).first
    ids = [0] << @exam.exam_absents.map(&:student_id) 
    @absent_students = @exam.students.where('students.id in (?)',  ids.flatten)
    ids << @exam.exam_results.map(&:student_id)
    @students = @exam.students.where('students.id not in (?)', ids.flatten)
    
  end

  def add_exam_results
    @exam = Exam.where(id: params[:id]).first
    @exam.add_exam_results(params[:students_results])
    redirect_to exam_path(@exam)
  end

  def publish_exam_result
    @exam = Exam.where(id: params[:id]).first
    if @exam
      @exam.publish_results
      @exam.update({is_result_decleared: true, is_completed: true})
    end
    redirect_to exams_path
  end
end
