class Organisation < ActiveRecord::Base

  validates :email, presence: true, uniqueness: {
    message: " allready registered. Please check email" }, format: { with: /\b[A-Z0-9._%a-z\-]+@(?:[A-Z0-9a-z\-]+\.)+[A-Za-z]{2,4}\z/}
  validates :name, presence: true
  validates :mobile, presence: true, format: { with: /\d{10}/, message: "should be 10 digit"}

  after_create :generate_email_code

  has_many :class_catlogs
  has_many :class_students
  has_many :daily_teaching_points
  has_many :documents
  has_many :exams
  has_many :exam_absents
  has_many :exam_catlogs
  has_many :exam_results
  has_many :jkci_classes
  has_many :notifications
  has_many :parents_meetings
  has_many :sms_sents
  has_many :students
  has_many :sub_classes
  has_many :teachers
  has_many :users
  has_many :organisation_standards
  has_many :standards,-> {uniq},  through: :organisation_standards

  cattr_accessor :current_id

  def generate_email_code
    e_code = (0...50).map { ('a'..'z').to_a[rand(26)] }.join
    m_code = (0...7).map { ('a'..'z').to_a[rand(26)] }.join
    update_attributes({email_code: e_code, mobile_code: m_code})
    self.send_generated_code
  end

  def send_generated_code
    org = Organisation.where(email: self.email).first
    if org.last_sent && ((org.last_sent + 5.hours) > Time.now)
    else
      org.update_attributes({last_sent: Time.now})
      Delayed::Job.enqueue OrganisationMailQueue.new(self)
      Delayed::Job.enqueue OrganisationRegistationSms.new(organisation_sms_message)
    end
  end

  def regenerate_organisation_code(mobile_number)
    m_code = (0...7).map { ('a'..'z').to_a[rand(26)] }.join
    update_attributes({mobile_code: m_code, mobile: mobile_number})
    Delayed::Job.enqueue OrganisationRegistationSms.new(organisation_sms_message)
  end


  def switch_organisation(new_organisation_id)
    
  end

  def switch_class_to_organisation(new_organisation_id, std)
    std.jkci_classes.first.exams.update_all({organisation_id: new_organisation_id})
    std.jkci_classes.first.exam_catlogs.update_all({organisation_id: new_organisation_id})
    std.jkci_classes.first.daily_teaching_points.update_all({organisation_id: new_organisation_id})
    std.jkci_classes.first.class_catlogs.update_all({organisation_id: new_organisation_id})
    std.jkci_classes.first.sub_classes.update_all({organisation_id: new_organisation_id})
    std.jkci_classes.first.students.update_all({organisation_id: new_organisation_id})
    std.jkci_classes.first.class_students.update_all({organisation_id: new_organisation_id})
    std.jkci_classes.first.notifications.update_all({organisation_id: new_organisation_id})
    std.jkci_classes.update_all({organisation_id: new_organisation_id})
    std.organisation_standards.update_all({organisation_id: new_organisation_id})
  end

  def organisation_sms_message
    message = "One time password is #{self.mobile_code}  for #{self.name} registation on EraCord. Please do not share OTP to any one for securiety reason."
    url = "https://www.txtguru.in/imobile/api.php?username=#{SMSUNAME}&password=#{SMSUPASSWORD}&source=update&dmobile=91#{self.mobile}&message=#{message}"
    url_arry = [url, message, self.id, self.id]
    
  end

  def manage_standards(standard_ids)
    new_standards = Standard.select([:id, :name, :stream]).where("id in (?)", (standard_ids.split(',').map(&:to_i) + [0]))
    new_standards = new_standards.where("id not in (?)", (self.standards.map(&:id) + [0]) )
    new_standards.each do |std|
      self.standards << std
      self.create_class(std)
    end
  end

  def create_class(standard)
    batch = Batch.active.last
    jkci_class = self.jkci_classes.find_or_create_by({standard_id: standard.id, batch_id: batch.id, class_name: "#{standard.std_name}-#{batch.name}"})
    jkci_class.update_attributes({is_active: true})
  end
end
