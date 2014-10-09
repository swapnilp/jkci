class ExamResultSmsSend < Struct.new(:exam)
  def perform
    send_sms(exam)
  end

  def send_sms(exam)
    exam.exam_catlogs.includes([:student]).only_results.each_with_index do |exam_catlog, index|
      message = "Your child got  #{exam_catlog.marks} out of #{exam.marks} in #{exam.name} exam. Please call us for further details"
      #"https://www.txtguru.in/imobile/api.php?username=swapnilpatil04&password=95183992&source=Senderid&dmobile=#{exam_catlog.student.p_mobile}&message=#{message}"
      SmsSent.new({number: exam_catlog.student.p_mobile, obj_type: "exam result", obj_id: exam_catlog.id, message: message, is_parent: true}).save
    end
  end
end
