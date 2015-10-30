class SmsSent < ActiveRecord::Base
  #self.inheritance_column = :obj_type

  after_save :update_record


  def update_record
    if self.obj_type == "absent_exam"
      exam_catlog = ExamCatlog.unscoped.where(id: obj_id).first
      exam_catlog.update_attributes({absent_sms_sent: true})
    end
    if self.obj_type == "exam_result"
      exam_catlog = ExamCatlog.unscoped.where(id: obj_id).first
      exam_catlog.update_attributes({absent_sms_sent: true})
    end
    if self.obj_type == "daily_teach_sms"
      class_catlog = ClassCatlog.unscoped.where(id: obj_id).first
      class_catlog.update_attributes({sms_sent: true})
    end
  end
  
end
