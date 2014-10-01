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
end
