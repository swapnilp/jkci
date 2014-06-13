class Subject < ActiveRecord::Base
  #attr_accessible :name
  has_many :teachers
  has_many :subjects
end
