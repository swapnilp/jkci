module ExamsHelper
  def exams_table_format(exams)
    table = [["Index", "Id", "Name", "Conducted By", "Marks", "Date", "Type", "Published Date", "Ignored"]]
    
    exams.each_with_index do |exam, index|
      table << ["#{index + 1}", "cx-#{exam.id}", "#{exam.name}", "#{exam.conducted_by}", "#{exam.marks}", "#{exam.exam_date.to_date}", "#{exam.exam_type}", "#{exam.published_date.try(&:to_date)}", "#{exam.ignored_count}"]
    end
    table
  end
end
