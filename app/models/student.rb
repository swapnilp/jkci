class Student < ActiveRecord::Base
 # attr_accessible :first_name, :middle_name, :last_name, :email, :mobile, :parent_name, :p_mobile, :p_email, :address, :group, :rank

  #has_many
  has_many :exam_absents
  has_many :exam_results
  has_many :class_students
  has_many :jkci_classes, through: :class_students
  
  def exams
    Exam.where(std: std, is_active: true)
  end

  def name
    "#{first_name} #{last_name}"
  end
  
end
