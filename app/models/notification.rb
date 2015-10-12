class Notification < ActiveRecord::Base

  def self.add_create_exam(obj_id)
    exam = Exam.where(id: obj_id).first
    if exam 
      Notification.new({object_type: "Exam", object_id: obj_id, message: "Exam #{exam.name} is created", url: "/exams/#{obj_id}?&notification=true", actions: "create_exam"}).save
    end
  end
  
  def self.verified_exam(obj_id)
    exam = Exam.where(id: obj_id).first
    if exam 
      Notification.new({object_type: "Exam", object_id: obj_id, message: "Exam #{exam.name} is verified", url: "/exams/#{obj_id}?&notification=true", actions: "verify_exam"}).save
    end
  end

  def self.exam_conducted(obj_id)
    exam = Exam.where(id: obj_id).first
    if exam 
      Notification.new({object_type: "Exam", object_id: obj_id, message: "Exam #{exam.name} is conducted. Please add absenty", url: "/exams/#{obj_id}?&notification=true", actions: "exam_conduct"}).save
    end
  end
  
  def self.add_exam_abesnty(obj_id)
    exam = Exam.where(id: obj_id).first
    if exam 
      notification = exam.notifications.where(actions: "add_exam_absenty").first
      if notification.present?
        notification.update_attributes({is_completed: false})
      else
        Notification.new({object_type: "Exam", object_id: obj_id, message: "Absenty is added for exam #{exam.name}", url: "/exams/#{obj_id}?&notification=true", actions: "add_exam_absenty"}).save
      end
    end
  end

  def self.verify_exam_abesnty(obj_id)
    exam = Exam.where(id: obj_id).first
    if exam 
      notification = exam.notifications.where(actions: "verify_exam_absenty").first
      if notification.present?
        notification.update_attributes({is_completed: false})
      else
        Notification.new({object_type: "Exam", object_id: obj_id, message: "Absenty is verifued for exam #{exam.name}.", url: "/exams/#{obj_id}?&notification=true", actions: "verify_exam_absenty"}).save
      end
    end
  end
  
  def self.add_exam_result(obj_id)
    exam = Exam.where(id: obj_id).first
    if exam
      notification = exam.notifications.where(actions: "add_exam_result").first
      if notification.present?
        notification.update_attributes({is_completed: false})
      else
        Notification.new({object_type: "Exam", object_id: obj_id, message: "Result has been added for exam #{exam.name}", url: "/exams/#{obj_id}?&notification=true", actions: "add_exam_result"}).save
      end
    end
  end

  def self.verify_exam_result(obj_id)
    exam = Exam.where(id: obj_id).first
    if exam 
      notification = exam.notifications.where(actions: "verify_exam_result").first
      if notification.present?
        notification.update_attributes({is_completed: false})
      else
        Notification.new({object_type: "Exam", object_id: obj_id, message: "Result has been verified for exam #{exam.name}. Please Publish Exam", url: "/exams/#{obj_id}?&notification=true", actions: "verify_exam_result"}).save
      end
    end
  end

  def self.publish_exam(obj_id)
    exam = Exam.where(id: obj_id).first
    if exam 
      Notification.new({object_type: "Exam", object_id: obj_id, message: "Exam #{exam.name} is published", url: "/exams/#{obj_id}?&notification=true", actions: "publish_exam"}).save
    end
  end

  def self.add_daily_teaches(obj_id)
    dtp = DailyTeachingPoint.where(id: obj_id).first
    if dtp
      Notification.new({object_type: "DailyTeaching_point", object_id: obj_id, message: "Daily Teaches is created for #{dtp.jkci_class.class_name}", url: "/daily_teachs/#{obj_id}?&notification=true"}).save
    end
  end

  def self.add_daily_teaches_adsenty(obj_id)
    dtp = DailyTeachingPoint.where(id: obj_id).first
    if dtp
      Notification.new({object_type: "DailyTeaching_point", object_id: obj_id, message: "Added absenty for  #{dtp.jkci_class.class_name}", url: "/daily_teachs/#{obj_id}?&notification=true"}).save
    end
  end

  def self.publish_daily_teaches_absenty(obj_id)
    dtp = DailyTeachingPoint.where(id: obj_id).first
    if dtp
      Notification.new({object_type: "DailyTeaching_point", object_id: obj_id, message: "Publish absenty for  #{dtp.jkci_class.class_name}", url: "/daily_teachs/#{obj_id}?&notification=true"}).save
    end
  end
end
