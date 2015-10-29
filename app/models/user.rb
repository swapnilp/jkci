class User < ActiveRecord::Base
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,# :recoverable,
          :rememberable, :trackable, :validatable, :authentication_keys => [:login, :organisation_id]
  attr_accessor :login

  has_many :students
  
  belongs_to :organisation


  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions.to_h).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      where(conditions.to_h).first
    end
  end
  
  def add_organiser_roles
    ["admin", "clark", "verify_exam", "exam_conduct", "verify_exam_absenty", "add_exam_result", "verify_exam_result", "publish_exam", "create_exam", "add_exam_absenty", "create_daily_teach", "add_daily_teach_absenty", "verify_daily_teach_absenty", "publish_daily_teach_absenty", "manage_class_sms"].each do |u_role|
      self.add_role u_role.to_sym 
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
