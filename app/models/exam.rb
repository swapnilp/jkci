class Exam < ActiveRecord::Base

  belongs_to :subject
  has_many :exam_absents
  has_many :exam_results
  has_many :absent_students, through: :exam_absents, source: :student
  has_many :present_students, through: :exam_results, source: :student
  belongs_to :jkci_class

  def students
    #Student.where(std: std, is_active: true)
    self.jkci_class.students
  end
  
  def add_absunt_students(exam_students)
    exam_students.each do |student|
      ExamAbsent.new({student_id: student, exam_id: self.id, sms_sent: false, email_sent: false}).save
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

  handle_asynchronously :send_result_email, :priority => 20
end
