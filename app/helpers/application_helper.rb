module ApplicationHelper
  
  def examDateColor(date)
    if (Date.today+ 1.day) .. (Date.today + 1.week)  === date
      'orange'
      if Date.today + 1.day == date
        'green'
      elsif Date.today < date
        'red'
      end
      
    end
  end

  def checkExam(exam)
    if exam.is_completed && exam.is_result_decleared
      'examComplete'
    elsif exam.is_completed 
      'examResultRemaining'
    elsif exam.exam_date < Date.today
      'examOverDate'
    elsif exam.exam_date < Date.today && exam.exam_date > Date.today - 8.day
      'examNear'
    else
      ''
    end
      
  end
end
