class DailyTeachingPoint < ActiveRecord::Base
  belongs_to :jkci_class
  belongs_to :teacher
  has_many :class_catlogs
end
