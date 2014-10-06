class Exam < ActiveRecord::Base

  belongs_to :subject
  #has_many :exam_absents
  has_many :exam_results
  #has_many :absent_students, through: :exam_absents, source: :student
  has_many :present_students, through: :exam_results, source: :student
  belongs_to :jkci_class
  has_many :exam_catlogs
  has_many :students, through: :exam_catlogs
  
  

  def exam_students
    #Student.where(std: std, is_active: true)
    if class_ids.nil?
      self.jkci_class.students rescue []
    else
      #JkciClass.where(id: class_ids.split(',').reject(&:blank?)).map(&:students)#.flatten.uniq
      Student.joins(:class_students).where("class_students.jkci_class_id in (?)", class_ids.split(',').reject(&:blank?)).uniq
    end
  end

  def absent_students
    students.where("exam_catlogs.is_present = ?", false)  
  end
  
  def add_absunt_students(exam_students)
    self.exam_catlogs.where(student_id: exam_students).update_all({is_present: false})
    #exam_students.each do |student|
      #ExamAbsent.new({student_id: student, exam_id: self.id, sms_sent: false, email_sent: false}).save
    #end
  end

  def jkci_classes
    unless class_ids.blank?
      JkciClass.where(id: class_ids.split(',').reject(&:blank?))
    else
      JkciClass.where(id: jkci_class_id)
    end
  end
  
  def add_exam_results(results)
    results.each do |id, marks|
      if marks.present?
        exam_result = ExamResult.new({exam_id: self.id, student_id: id, marks: marks, sms_sent: false, email_sent: false, late_attend: false})
        exam_result.save
        #self.send_result_email(self, exam_result.student)
      end
    end
  end

  def publish_results
    self.exam_results.each do |exam_result|
      self.send_result_email(self, exam_result.student)
    end
  end

  def send_result_email(exam, student)
    UserMailer.delay.send_result(exam, student)
  end

  def exam_student_marks(student)
    result = exam_results.where(student_id: student.id).first
    result.marks    
  end

  def complete_exam
    self.update_attributes({is_completed: true})
    exam_students.each do |student|
      self.exam_catlogs.build({student_id: student.id, jkci_class_id: self.jkci_class_id}).save
    end
  end

  def dtps
    DailyTeachingPoint.where(id: daily_teaching_points.split(',').reject(&:blank?)) rescue []
  end

  handle_asynchronously :send_result_email, :priority => 20
end
