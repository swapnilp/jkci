class ExamResultSmsSend < Struct.new(:exam)
  include SendingSms
  def perform
    send_sms(exam)
  end

  def send_sms(exam)
    exam.exam_catlogs.includes([:student]).only_results.each_with_index do |exam_catlog, index|
      if exam_catlog.student.enable_sms
        message = "#{exam_catlog.student.first_name} got #{exam_catlog.marks} out of #{exam.marks} in #{exam.name} exam. Please call us for further details. JKSai"
        message = message.truncate(159)
        url = "https://www.txtguru.in/imobile/api.php?username=#{SMSUNAME}&password=#{SMSUPASSWORD}&source=JKSAIU&dmobile=#{exam_catlog.student.sms_mobile}&message=#{message}"
        deliver_sms(URI::encode(url))
        SmsSent.new({number: exam_catlog.student.p_mobile, obj_type: "exam result", obj_id: exam_catlog.id, message: message, is_parent: true}).save
      end
    end
  end
end
#Delayed::Job.enqueue ExamResultSmsSend.new(Exam.last)
