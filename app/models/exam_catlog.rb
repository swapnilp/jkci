class ExamCatlog < ActiveRecord::Base

  belongs_to :exam
  belongs_to :student

  scope :only_absents, -> {where(is_present: [nil, false], is_recover: [nil, false])}
  scope :only_results, -> {where("marks is not ?", nil)}
  scope :only_ignored, -> {where("is_ingored is not ?", nil)}
  scope :completed, -> {where("is_present in (?)",  [true, false])}

  def exam_report
    r_name = "#{exam.name} "
    if exam.marks.present?
      r_name << "  |  marks - #{marks || 'not available'}/#{exam.marks}"
    end
    if is_recover
      r_name << " | Recovered"
    end
    r_name
    
  end

  def is_absent?
    return self.is_present == false
  end
end
