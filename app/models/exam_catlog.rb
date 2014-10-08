class ExamCatlog < ActiveRecord::Base

  belongs_to :exam
  belongs_to :student

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
end
