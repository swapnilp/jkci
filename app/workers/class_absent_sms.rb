class ClassAbsentSms < Struct.new(:daily_teaching_point)
  include SendingSms
  def perform
    send_sms(daily_teaching_point)
  end

  def send_sms(daily_teaching_point)
    daily_teaching_point.class_catlogs.includes([:jkci_class, :student]).only_absents.each_with_index do |class_catlog, index|
      if class_catlog.student.enable_sms
        message = "We regret to convey you that your son/daughter #{class_catlog.student.short_name} is absent for #{daily_teaching_point.jkci_class.class_name} lectures.Plz contact us. JKSai!!"
        url = "https://www.txtguru.in/imobile/api.php?username=#{SMSUNAME}&password=#{SMSUPASSWORD}&source=update&dmobile=#{class_catlog.student.sms_mobile}&message=#{message}"
        unless class_catlog.sms_sent
          deliver_sms(URI::encode(url))
          class_catlog.update_attributes({sms_sent: true})
          SmsSent.new({obj_type: "daily_teach_sms", obj_id: daily_teaching_point.id, message: message, is_parent: true, organisation_id: organisation.id}).save
        end
      end
    end
    daily_teaching_point.update_attributes({is_sms_sent: true})
  end
end
#Delayed::Job.enqueue ClassAbsentSms.new(DailyTeachingPoint.last)
