class SmsSend
  @queue = :sms
  def self.perform(number, msg)
    p "!!!!!!!!!!!!!!!!!!!!!!!!!!"
    p msg
    #UserMailer.send_result(exam, student).deliver
  end
end

