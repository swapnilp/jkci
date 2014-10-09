class ClassCatlog < ActiveRecord::Base
  belongs_to :jkci_class
  belongs_to :student
  belongs_to :daily_teaching_point
  
  validates :student_id, uniqueness: {scope: [:jkci_class_id, :daily_teaching_point_id, :date]}

  scope :absent, -> {where(is_present: [false, nil]) }
  scope :only_absents, -> {where(is_present: [nil, false], is_recover: [nil, false])}

    def class_report
    r_name = "#{jkci_class.class_name} "
      r_name << "  |  points - #{daily_teaching_point.points.truncate(30)}"
       if is_recover
      r_name << " | Recovered"
    end
    r_name
  end

end
