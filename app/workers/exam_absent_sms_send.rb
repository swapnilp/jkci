class ExamAbsentSmsSend < Struct.new(:exam)
  include SendingSms
  def perform
    send_sms(exam)
  end

  def send_sms(exam)
    exam.exam_catlogs.includes([:student]).only_absents.in_groups_of(50).each_with_index do |exam_catlog_group, index|
      message = "Your child is not attended #{exam.name} exam. Please contact with us"
      url = "https://www.txtguru.in/imobile/api.php?username=#{SMSUNAME}&password=#{SMSUPASSWORD}&source=update&dmobile=#{exam_catlog_group.compact.map(&:student).map(&:p_mobile).join(',')}&message=#{message}"
      deliver_sms(URI::encode(url))
      SmsSent.new({number: index, obj_type: "absent_exam", obj_id: exam.id, message: message, is_parent: true}).save
    end
  end
end
#Delayed::Job.enqueue ExamAbsentSmsSend.new(Exam.last)
