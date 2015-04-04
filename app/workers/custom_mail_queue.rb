class CustomMailQueue
  @queue = :mailer
  def self.perform(students, message)
    students.split(',').each do |student|
      CustomMailer.send_custom_mail(student, msg).deliver
    end
  end
end
