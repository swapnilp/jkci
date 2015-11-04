class User < ActiveRecord::Base
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,# :recoverable,
          :rememberable, :trackable, :authentication_keys => [:login, :organisation_id]#, request_keys: [:organisation_id]
  attr_accessor :login

  has_many :students
  
  belongs_to :organisation
  
  validates :organisation_id, :presence => true#, :email => true, scope: :organisation_id

  
  validates_uniqueness_of :email, :scope => :organisation_id, :case_sensitive => false, :allow_blank => true#, :if => true
  validates_format_of :email, :with => Devise.email_regexp, :allow_blank => true, :if => :email_changed?
  validates_presence_of :password, :on=>:create
  validates_confirmation_of :password, :on=>:create
  validates_length_of :password, :within => Devise.password_length, :allow_blank => true

  scope :clarks, -> {where(role: 'clark')}

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if (login = conditions.delete(:login)) && (org = conditions.delete(:organisation_id)) 
      where(conditions.to_h).where(["(lower(username) = :value OR lower(email) = :value) AND organisation_id = :org", { :value => login.downcase, org: org }]).first
    else
      where(conditions.to_h).first
    end
  end
  
  def after_database_authentication
    self.organisation.update_attributes({last_signed_in: Time.now}) if self.organisation.present?
  end 

  def active_for_authentication?
    super && is_enable
  end

  def add_organiser_roles
    ["admin", "clark", "verify_exam", "exam_conduct", "verify_exam_absenty", "add_exam_result", "verify_exam_result", "publish_exam", "create_exam", "add_exam_absenty", "create_daily_teach", "add_daily_teach_absenty", "verify_daily_teach_absenty", "publish_daily_teach_absenty", "manage_class_sms"].each do |u_role|
      self.add_role u_role.to_sym 
    end
  end

  def manage_clark_roles(new_roles)
    self.roles = []
    new_roles = new_roles.split(',') + ["clark"]
    new_roles.each do |u_role| 
      self.add_role u_role.to_sym if CLARK_ROLES.include?(u_role) 
    end
  end
  
  def admin?
    return role == 'admin'
  end

  def organiser?
    return role == 'organisation'
  end

  def staff?
    return role == 'staff'
  end

  def clark?
    return role == 'clark'
  end

  def parent?
    return role == 'parent'
  end

  def login=(login)
    @login = login
  end

  def login
    @login || self.username || self.email
  end
end
