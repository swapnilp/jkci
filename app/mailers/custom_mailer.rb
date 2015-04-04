class CustomMailer < ActionMailer::Base
  default from: "swapnil.patil04@gmail.com"
  
  def welcome_user
    mail(to: 'swapnil.patil04@gmail.com', subject: 'Welcome Mail')
  end
  
  def send_result(exam, student)
    @student = student
    @exam = exam
    mail(to: student.p_email, subject: "#{@exam.name} results has been decleared")
  end

  def send_custom_mail(student, msg, subject = "JKScience Academy.Learning Today . . . Leading Tomorrow..")
    @student = student
    @msg = msg
    mail(to: student, subject: subject)
  end
end


