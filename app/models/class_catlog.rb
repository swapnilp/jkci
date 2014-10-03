class ClassCatlog < ActiveRecord::Base
  belongs_to :jkci_class
  belongs_to :student
  belongs_to :daily_teaching_point
  
  validates :student_id, uniqueness: {scope: [:jkci_class_id, :daily_teaching_point_id, :date]}
end
