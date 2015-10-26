class ExamResultSmsSend < Struct.new(:exam)
  include SendingSms
  def perform
    send_sms(exam)
  end

  def send_sms(exam)
    exam.exam_catlogs.includes([:student]).only_results.each_with_index do |exam_catlog, index|
      if exam_catlog.student.enable_sms
        message = "#{exam_catlog.student.short_name} got #{exam_catlog.marks.to_i}/#{exam.marks} in cx-#{exam.id} exam held on #{exam.exam_date.strftime("%B-%d")}. JKSai"
        message = message.truncate(159)
        url = "https://www.txtguru.in/imobile/api.php?username=#{SMSUNAME}&password=#{SMSUPASSWORD}&source=JKSAIU&dmobile=#{exam_catlog.student.sms_mobile}&message=#{message}"
        deliver_sms(URI::encode(url))
        SmsSent.new({number: exam_catlog.student.p_mobile, obj_type: "exam result", obj_id: exam_catlog.id, message: message, is_parent: true}).save
      end
    end
  end
end
#Delayed::Job.enqueue ExamResultSmsSend.new(Exam.last)
