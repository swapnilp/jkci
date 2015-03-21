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

  def event_select(cur_path)
    cur_path == 'events' ? 'current-menu-item' : ''
  end
  
  def course_select(cur_path)
    cur_path == 'courses' ? 'current-menu-item' : ''
  end
  
  def gallery_select(cur_path)
    cur_path == 'galleries' ? 'current-menu-item' : ''
  end

  def about_select(cur_path)
    cur_path == 'about_us' ? 'current-menu-item' : ''
  end
  
  def home_select(cur_path)
    return cur_path == root_path ? 'current-menu-item' : ''
  end
  
  
  def parentStudentCatlog(catlog)
    if !catlog.is_present && !catlog.is_recover
      return 'studentAbsent'
    elsif  !catlog.is_present && catlog.is_recover
      return 'studentRecovered'
    end
    return ''
  end
end
