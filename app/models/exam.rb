class Exam < ActiveRecord::Base

  belongs_to :subject
  has_many :exam_absents
  has_many :exam_results

  def students
    Student.where(std: std, is_active: true)
  end
  
  def add_absunt_students(students)
    students.each do |student|
      ExamAbsent.new({student_id: student, exam_id: self.id, sms_sent: false, email_sent: false}).save
    end
  end
  
  def add_exam_results(results)
    results.each do |id, marks|
      if marks.present?
        exam_result = ExamResult.new({exam_id: self.id, student_id: id, marks: marks, sms_sent: false, email_sent: false, late_attend: false})
        exam_result.save
        self.delay.send_result_email(self, exam_result.student)
      end
    end
  end

  def send_result_email(exam, student)
    UserMailer.send_result(exam, student)
  end

  def exam_student_marks(student)
    result = exam_results.where(student_id: student.id).first
    result.marks    
  end

  handle_asynchronously :send_result_email
end
