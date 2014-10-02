class ClassCatlog < ActiveRecord::Base
  belongs_to :jkci_class
  belongs_to :student
  belongs_to :daily_teaching_point
end
