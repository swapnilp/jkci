class ExamAbsentSmsSend < Struct.new(:exam)
  include SendingSms
  def perform
    send_sms(exam)
  end
  
  def send_sms(exam)
    exam.exam_catlogs.includes([:student]).only_absents.each_with_index do |exam_catlog, index|
      if exam_catlog.student.enable_sms && !exam_catlog.absent_sms_sent.present?
        #message = "#{exam_catlog.student.first_name} is not attended #{exam.name} exam held on #{exam.exam_date.strftime("%B-%d")}. Please contact with us.JKSAI !!!"
        message = "We regret to convey you that #{exam_catlog.student.short_name} is absent for #{exam.name} exam.Plz contact us. JKSai!!"
        url = "https://www.txtguru.in/imobile/api.php?username=#{SMSUNAME}&password=#{SMSUPASSWORD}&source=JKSaiu&dmobile=#{exam_catlog.student.sms_mobile}&message=#{message}"
        if exam_catlog.student.sms_mobile.present? && exam_catlog.absent_sms_sent != true
          deliver_sms(URI::encode(url))
          SmsSent.new({number: index, obj_type: "absent_exam", obj_id: exam.id, message: message, is_parent: true}).save
          exam_catlog.update_attributes({absent_sms_sent: true})
        end
      end
    end
  end
end
#Delayed::Job.enqueue ExamAbsentSmsSend.new(Exam.last)

