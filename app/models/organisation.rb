class Organisation < ActiveRecord::Base

  has_ancestry

  belongs_to :master_organisation,   :class_name => "Organisation", :foreign_key => "parent_id"
  has_many   :sub_organisations,    :class_name => "Organisation", :foreign_key => "parent_id", :dependent => :destroy

  scope :master_organisations, lambda{ where(master_organisation: nil) }
  
  validates :email, presence: true, format: { with: /\b[A-Z0-9._%a-z\-]+@(?:[A-Z0-9a-z\-]+\.)+[A-Za-z]{2,4}\z/}
  validates :email, uniqueness: { message: " allready registered. Please check email" }, if: Proc.new { |org| org.parent_id.nil? }
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
    self.update_attributes({super_organisation_id: self.root_id})
   
  end

  def master_organisation?
    parent_id == nil
  end

  def assigned_standards
    standards.where("organisation_standards.is_assigned_to_other is true")
  end
  
  def unassigned_standards
    standards.where("organisation_standards.is_assigned_to_other is false")
  end

  def standards_name
    OrganisationStandard.unscoped.where(organisation_id: self.id).map(&:standard).flatten.map(&:std_name).join(", ")
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

  def pull_back_organisation(old_organisation_id)
    old_org = Organisation.where(id: old_organisation_id).first
    #old_org.sub_organisations.update_all({parent_id: self.id})
    
  end

  def launch_sub_organisation(new_sub_organisation_id, std)
    # assign standard to new organisation when launch sub organisation
 
    new_organisation = Organisation.where(id: new_sub_organisation_id).first
    if new_organisation
      self.organisation_standards.where(standard_id: std.id).first.update_attributes({is_assigned_to_other: true})
      new_organisation.standards << std rescue nil
      if std.jkci_classes.present?
        std.jkci_classes.map(&:exams).flatten.each{ |record| record.update_attributes({organisation_id: new_sub_organisation_id}) }
        std.jkci_classes.map(&:exam_catlogs).flatten.each{ |record| record.update_attributes({organisation_id: new_sub_organisation_id})}
        std.jkci_classes.map(&:daily_teaching_points).flatten.each{ |record| record.update_attributes({organisation_id: new_sub_organisation_id})}
        std.jkci_classes.map(&:class_catlogs).flatten.each{ |record| record.update_attributes({organisation_id: new_sub_organisation_id})}
        std.jkci_classes.map(&:sub_classes).flatten.each{ |record| record.update_attributes({organisation_id: new_sub_organisation_id})}
        std.jkci_classes.map(&:students).flatten.each{ |record| record.update_attributes({organisation_id: new_sub_organisation_id})}
        std.jkci_classes.map(&:class_students).flatten.each{ |record| record.update_attributes({organisation_id: new_sub_organisation_id})}
        std.jkci_classes.map(&:notifications).flatten.each{ |record| record.update_attributes({organisation_id: new_sub_organisation_id})}
        OrganisationStandard.unscoped.where(standard_id: std.id, organisation_id: new_organisation.ancestor_ids).update_attributes({assigned_organisation_id: new_sub_organisation_id})
      end
      std.jkci_classes.update_all({organisation_id: new_sub_organisation_id})
      
    end
  end

  def pull_back_standard_to_master_organisation(old_organisation_id, std)
    # pull back organisaiton standards classes from sub organisation to master organisation

    old_organisation = Organisation.where(id: old_organisation_id).first
    unless old_organisation.root?
      class_ids = JkciClass.unscoped.where(standard_id: std.id, organisation_id: old_organisation_id).map(&:id)
      
      if class_ids.present?
        Exam.unscoped.where(jkci_class_id: class_ids, organisation_id: old_organisation_id).update_all({organisation_id: self.id})
        ExamCatlog.unscoped.where(jkci_class_id: class_ids, organisation_id: old_organisation_id).update_all({organisation_id: self.id})
        DailyTeachingPoint.unscoped.where(jkci_class_id: class_ids, organisation_id: old_organisation_id).update_all({organisation_id: self.id})
        ClassCatlog.unscoped.where(jkci_class_id: class_ids, organisation_id: old_organisation_id).update_all({organisation_id: self.id})
        SubClass.unscoped.where(jkci_class_id: class_ids, organisation_id: old_organisation_id).update_all({organisation_id: self.id})
        Student.unscoped.where(standard_id: std.id, organisation_id: old_organisation_id).update_all({organisation_id: self.id})
        ClassStudent.unscoped.where(jkci_class_id: class_ids, organisation_id: old_organisation_id).update_all({organisation_id: self.id})
        Notification.unscoped.where(jkci_class_id: class_ids, organisation_id: old_organisation_id).update_all({organisation_id: self.id})
        JkciClass.unscoped.where(standard_id: std.id, organisation_id: old_organisation_id).update_all({organisation_id: self.id})
        OrganisationStandard.unscoped.where(standard_id: std.id, organisation_id: self.descendant_ids).destroy_all
        self.organisation_standards.where(standard_id: std.id).update_all({is_assigned_to_other: false})
      end
    end
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
    if self.assigned_standards.include?(standard)
      jkci_class = self.jkci_classes.find_or_create_by({standard_id: standard.id, batch_id: batch.id, class_name: "#{standard.std_name}-#{batch.name}"})
      jkci_class.update_attributes({is_active: true})
    end
  end
end
