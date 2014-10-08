class HomeController < ApplicationController


  def index
    @class_absents = ClassCatlog.includes([:student, :daily_teaching_point]).where(is_present: [nil, false], is_recover: false, is_followed: false).where("created_at >  ? ", Date.today - 2.week)
    @exam_absents = ExamCatlog.joins([:exam]).includes([:student, :exam]).where(is_present: [nil, false], is_recover: [nil, false], is_followed: false).where("exams.exam_date >  ? ", Date.today - 3.week)

    @unconducted_exams = Exam.where(is_completed: [nil, false])
    @recent_exams = Exam.where(is_completed: true, is_result_decleared: [nil, false])
    @todays_exams = Exam.where("exam_date < ? && exam_date > ? ", Date.today + 1.day, Date.today - 1.day)
  end
end
