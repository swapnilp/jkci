class Subject < ActiveRecord::Base
  #attr_accessible :name
  has_many :teachers
  has_many :subjects
  has_many :jkci_classes
  has_many :chapters
end
