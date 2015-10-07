class Subject < ActiveRecord::Base
  #attr_accessible :name
  has_many :teachers
  has_many :jkci_classes
  has_many :chapters
  belongs_to :standard
  
  def std_name
    "#{name}-#{standard.std_name}"
  end
end
