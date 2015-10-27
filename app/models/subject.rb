class Subject < ActiveRecord::Base
  #attr_accessible :name
  has_many :teachers
  has_many :jkci_classes
  has_many :chapters
  has_many :student_subjects
  has_many :students, through: :student_subjects
  belongs_to :standard

  scope :compulsory, -> { where(is_compulsory: true) }
  scope :optional, -> { where(is_compulsory: false) }
  
  def std_name
    "#{name}-#{standard.std_name}"
  end
end
