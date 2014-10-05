class DailyTeachingPoint < ActiveRecord::Base
  belongs_to :jkci_class
  belongs_to :teacher
  has_many :class_catlogs

  def absent_count
    students_count = self.class_catlogs.where(is_present: false).count
    students_count.zero? ? "" : "absents : #{students_count}"
  end
  
  def exams
    Exam.where("daily_teaching_points like '%?%'", self.id)
  end
end
