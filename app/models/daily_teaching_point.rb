class DailyTeachingPoint < ActiveRecord::Base
  
  belongs_to :jkci_class
  belongs_to :teacher
  has_many :class_catlogs
  belongs_to :chapter
  belongs_to :chapters_point
  
  scope :chapters_points, -> { where("chapter_id is not ?", nil) }

  after_save :add_current_chapter

  def absent_count
    students_count = self.class_catlogs.where(is_present: false).count
    students_count.zero? ? "" : " #{students_count}"
  end
  
  def exams
    Exam.where("daily_teaching_points like '%?%'", self.id)
  end

  def create_catlog
    self.jkci_class.students.each do |student|
      self.class_catlogs.build({student_id: student.id, date: self.date, jkci_class_id: self.jkci_class_id}).save
    end
  end

  def fill_catlog(present_list,  date)
    self.update_attributes({is_fill_catlog: true}) unless self.is_fill_catlog
    class_catlogs.each do |class_catlog|
      if present_list.map(&:to_i).include?(class_catlog.student_id)
        class_catlog.update_attributes({is_present: false, date: date})
      else
        class_catlog.update_attributes({is_present: true, date: date})
      end
    end
  end

  def add_current_chapter
    self.jkci_class.update_attributes({current_chapter_id: self.chapter_id})
  end

  def publish_absenty
    Delayed::Job.enqueue ClassAbsentSms.new(self)
  end
end
