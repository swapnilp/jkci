class ActivationSms < Struct.new(:student)
  include SendingSms
  def perform
    send_sms(student)
  end
  
  def send_sms(student)
    #if class_catlog.student.enable_sms
    message = "#{student.short_name}'s notification updates has been activaed by JKSAi. JKSai!!"
    url = "https://www.txtguru.in/imobile/api.php?username=#{SMSUNAME}&password=#{SMSUPASSWORD}&source=update&dmobile=91#{student.p_mobile}&message=#{message}"
    if student.sms_mobile.present?
      deliver_sms(URI::encode(url))
      SmsSent.new({obj_type: "activation_sms", obj_id: student.id, message: message, is_parent: true, organisation_id: student.organisation_id}).save
    end
    #end
  end
end
#Delayed::Job.enqueue ActivationSms.new(student)
