class ClassAbsentSms < Struct.new(:daily_teaching_point)
  def perform
    send_sms(daily_teaching_point)
  end

  def send_sms(daily_teaching_point)
    daily_teaching_point.class_catlogs.includes([:jkci_class, :student]).only_absents.in_groups_of(50).each_with_index do |class_catlog_group, index|
      message = "Your child is not attended #{daily_teaching_point.jkci_class.class_name} class. Please contact with us and recover dp#{daily_teaching_point.id} point"
      #"https://www.txtguru.in/imobile/api.php?username=swapnilpatil04&password=95183992&source=update&dmobile=#{class_catlog_group.compact.map(&:student).map(&:p_mobile).join(',')}&message=#{message}"
      SmsSent.new({number: index, obj_type: "class_exam", obj_id: daily_teaching_point.id, message: message, is_parent: true}).save
    end
  end
end
#Delayed::Job.enqueue ClassAbsentSms.new(DailyTeachingPoint.last)
