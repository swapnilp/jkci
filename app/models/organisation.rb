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
      Delayed::Job.enqueue OrganisationRegistationSms.new(self)
      
    end
  end

  def regenerate_organisation_code(mobile_number)
    m_code = (0...7).map { ('a'..'z').to_a[rand(26)] }.join
    update_attributes({mobile_code: m_code, mobile: mobile_number})
    Delayed::Job.enqueue OrganisationRegistationSms.new(self)
  end
end
