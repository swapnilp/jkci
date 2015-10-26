class Exam < ActiveRecord::Base

  belongs_to :subject
  #has_many :exam_absents
  #has_many :exam_results
  #has_many :absent_students, through: :exam_absents, source: :student
  #has_many :present_students, through: :exam_results, source: :student
  belongs_to :jkci_class
  has_many :exam_catlogs
  has_many :students, through: :exam_catlogs
  has_many :documents
  has_many :notifications, -> {where("notifications.object_type like ?", 'Exam')}, :foreign_key => :object_id
  
  default_scope { where(is_active: true) }
  
  scope :upcomming_exams, -> { where("exam_date > ? && is_completed is ?", Date.tomorrow, nil) }
  scope :unconducted_exams, -> { where("exam_date < ? && is_completed is ?", Date.today, nil).order("id desc")}
  scope :todays_exams, -> { where("exam_date BETWEEN ? AND ? ", Date.today, Date.tomorrow)}
  scope :unpublished_exams, -> { where(is_result_decleared: [nil, false], is_completed: true).order("id desc")}
  
  validates :name, :exam_type, :exam_date, :marks,  presence: true
  
  def exam_students
    #Student.where(std: std, is_active: true)
    if sub_classes.present?
      self.jkci_class.sub_classes_students(self.sub_classes.split(',').map(&:to_i)) rescue []
    elsif class_ids.nil?
      self.jkci_class.students rescue []
    else 
      #JkciClass.where(id: class_ids.split(',').reject(&:blank?)).map(&:students)#.flatten.uniq
      Student.joins(:class_students).where("class_students.jkci_class_id in (?)", class_ids.split(',').reject(&:blank?)).uniq
    end
  end

  def role_notification(user)
    user_roles = user.roles.select([:name]).map(&:name).map(&:to_sym)
    notification_roles = NOTIFICATION_ROLES.slice(*user_roles).values.flatten
    notifications.where(actions: notification_roles)
    #self.notifications
  end

  def exam_results
    exam_catlogs.where("(is_present = ?  || is_recover= ? ) && marks is not  ?", true, true, nil)  
  end

  def ignored_count
    exam_catlogs.only_ignored.count
  end

  def absent_students
    students.where("exam_catlogs.is_present = ? && exam_catlogs.is_recover = ?", false, false)  
  end
  
  def add_absunt_students(exam_absent_students)
    self.exam_catlogs.where(student_id: exam_absent_students).update_all({is_present: false})
    Notification.add_exam_abesnty(self.id, self.organisation)
    self.update_attributes({verify_absenty: false})
    #exam_students.each do |student|
      #ExamAbsent.new({student_id: student, exam_id: self.id, sms_sent: false, email_sent: false}).save
    #end
  end

  def remove_absent_student(student_id)
    self.exam_catlogs.where(student_id: student_id).update_all({is_present: nil, is_recover: nil})
    Notification.add_exam_abesnty(self.id, self.organisation)
    self.update_attributes({verify_absenty: false})
  end

  def jkci_classes
    unless class_ids.blank?
      JkciClass.where(id: class_ids.split(',').reject(&:blank?))
    else
      JkciClass.where(id: jkci_class_id)
    end
  end
  
  def add_exam_results(results)
    results.each do |s_id, marks|
      if marks.present?
        self.exam_catlogs.where(student_id: s_id).first.update_attributes({marks: marks, is_present: true})
        #exam_result = ExamResult.new({exam_id: self.id, student_id: id, marks: marks, sms_sent: false, email_sent: false})
        #exam_result.save
        #self.send_result_email(self, exam_result.student)
      end
    end
    Notification.add_exam_result(self.id, self.organisation)
    self.update_attributes({verify_result: false})
  end
  
  def verify_exam_result
    self.update_attributes({verify_result: true})
    self.ranking
    Notification.verify_exam_result(self.id, self.organisation)
  end

  def remove_exam_result(catlog_id)
    self.exam_catlogs.where(id: catlog_id).update_all({marks: nil, is_present: nil})
    Notification.add_exam_result(self.id, self.organisation)
    self.update_attributes({verify_result: false})
  end

  def add_ignore_student(student_id)
    self.exam_catlogs.where(student_id: student_id).first.update_attributes({is_ingored: true})
  end

  def remove_ignore_student(student_id)
    self.exam_catlogs.where(student_id: student_id).first.update_attributes({is_ingored: nil})
  end

  def publish_results
    Delayed::Job.enqueue ExamAbsentSmsSend.new(self)
    Delayed::Job.enqueue ExamResultSmsSend.new(self)
    self.update_attributes({is_result_decleared: true, is_completed: true, published_date: Time.now})
    Notification.publish_exam(self.id, self.organisation)
  end

  def publish_absentee
    Delayed::Job.enqueue ExamAbsentSmsSend.new(self)
  end
  
  def send_result_email(exam, student)
    UserMailer.delay.send_result(exam, student)
  end

  def exam_student_marks(student)
    result = exam_results.where(student_id: student.id).first
    result.marks    
  end

  def complete_exam
    self.update_attributes({is_completed: true})
    exam_students.each do |student|
      self.exam_catlogs.build({student_id: student.id, jkci_class_id: self.jkci_class_id, organisation_id: self.organisation_id}).save
    end
    Notification.exam_conducted(self.id, self.organisation)
  end

  def predict_name
    "#{jkci_class.subject.std_name}-#{Exam.last.id + 1}"
  end
  
  def status_count
  end
  
  def ranking
    results = self.exam_results.map(&:marks).uniq
    results = results.sort { |x,y| y <=> x }
    rank = 1
    result_ranks = results.each_with_index.map{|value, i| results[i-1] == value ? {value => rank} : {value => (rank = i+1)}}
    result_ranks = result_ranks.reduce Hash.new, :merge
    self.exam_results.each do |exam_result|
      exam_result.update_attributes({rank: result_ranks[exam_result.marks]})
    end
  end

  def exam_table_format
    table = [["Index", "Name", "Parent Mobile", "Is Present", "Marks", "Rank"]]
    if self.is_result_decleared
      catlogs =  self.exam_catlogs.order("rank asc")
    else
      catlogs =  self.exam_catlogs
    end
    catlogs.each_with_index do |exam_catlog, index|
      table << ["#{index+1}", "#{exam_catlog.student.name}", "#{exam_catlog.student.p_mobile}", "#{exam_catlog.is_present}", "#{exam_catlog.marks}", "#{exam_catlog.rank}"]
    end
    table
  end
  
  def dtps
    DailyTeachingPoint.where(id: daily_teaching_points.split(',').reject(&:blank?)) rescue []
  end

  handle_asynchronously :send_result_email, :priority => 20
end
