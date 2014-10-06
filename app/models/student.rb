class Student < ActiveRecord::Base
 # attr_accessible :first_name, :middle_name, :last_name, :email, :mobile, :parent_name, :p_mobile, :p_email, :address, :group, :rank

  #has_many
  has_many :exam_absents
  has_many :exam_results
  has_many :class_students
  has_many :jkci_classes, through: :class_students
  has_many :class_catlogs
  has_many :exam_catlogs
  has_many :exams, through: :exam_catlogs 
  
  def all_exams
    #Exam.where(std: std, is_active: true)
    Exam.where("jkci_class_id in (?)  or ?", self.jkci_classes.map(&:id), exam_query)
  end

  def name
    "#{first_name} #{last_name}"
  end
  
  def exam_query
    query = " "
    ids = self.jkci_classes.map(&:id)
    ids.each do |class_id|
      query << "class_ids like '%,#{class_id},%'"
      unless ids.last == class_id
        query << " or "
      end
    end
    query
  end
end
