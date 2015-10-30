class DailyTeachingPoint < ActiveRecord::Base
  
  belongs_to :jkci_class
  belongs_to :teacher
  has_many :class_catlogs
  belongs_to :subject
  belongs_to :chapter
  belongs_to :chapters_point
  has_many :notifications, -> {where("notifications.object_type like ?", 'DailyTeaching_point')}, :foreign_key => :object_id 
  
  default_scope { where(organisation_id: Organisation.current_id) }
  scope :chapters_points, -> { where("chapter_id is not ?", nil) }
  after_save :add_current_chapter
  

  def absent_count
    students_count = self.class_catlogs.where(is_present: false).count
    students_count.zero? ? "" : " #{students_count}"
  end

  def role_notification(user)
    user_roles = user.roles.select([:name]).map(&:name).map(&:to_sym)
    notification_roles = NOTIFICATION_ROLES.slice(*user_roles).values.flatten
    notifications.where(actions: notification_roles)
    #self.notifications
  end

  def chapter_points
    if self.chapter.present? && self.chapters_point_id.present?
      self.chapter.chapters_points.where(id: chapters_point_id.split(',').map(&:to_i)).map(&:name).join(', ')
    else
      return ""
    end
  end

  def class_students
    #Student.where(std: std, is_active: true)
    if sub_classes.present?
      self.jkci_class.sub_classes_students(self.sub_classes.split(',').map(&:to_i), self.subject) rescue []
    else 
      self.subject.students.joins(:class_students).where("class_students.jkci_class_id = ?", self.jkci_class_id) rescue []
    end
  end
  
  def exams
    Exam.where("daily_teaching_points like '%?%'", self.id)
  end

  def create_catlog
    class_students.each do |student|
      self.class_catlogs.build({student_id: student.id, date: self.date, jkci_class_id: self.jkci_class_id, organisation_id: self.organisation_id}).save
    end
  end

  def fill_catlog(present_list,  date)
    self.update_attributes({is_fill_catlog: true, verify_absenty: false})
    class_catlogs.each do |class_catlog|
      if present_list.map(&:to_i).include?(class_catlog.student_id)
        class_catlog.update_attributes({is_present: false, date: date})
      else
        class_catlog.update_attributes({is_present: true, date: date})
      end
    end
  end

  def add_current_chapter
    self.jkci_class.update_attributes({current_chapter_id: self.chapter_id})
  end

  def publish_absenty
    if self.jkci_class.enable_class_sms
      Delayed::Job.enqueue ClassAbsentSms.new(self.absenty_message_send) 
      self.update_attributes({is_sms_sent: true}) 
    end
  end

  def absenty_message_send
    url_arry = []
    self.class_catlogs.includes([:jkci_class, :student]).only_absents.each_with_index do |class_catlog, index|
      if class_catlog.student.enable_sms
        message = "We regret to convey you that your son/daughter #{class_catlog.student.short_name} is absent for #{self.jkci_class.class_name} lectures.Plz contact us. JKSai!!"
        url = "https://www.txtguru.in/imobile/api.php?username=#{SMSUNAME}&password=#{SMSUPASSWORD}&source=update&dmobile=#{class_catlog.student.sms_mobile}&message=#{message}"
        unless class_catlog.sms_sent
          url_arry << [url, message, class_catlog.id, self.organisation_id]
          #class_catlog.update_attributes({sms_sent: true})
        end
      end
    end
    url_arry
  end

  
end
