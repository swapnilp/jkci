class HomeController < ApplicationController
  load_and_authorize_resource :class => false, :class => "Gallery"
  before_action :authenticate_user!, only: [:admin_desk]
  #load_and_authorize_resource :class => false

  def index
    @events = Event.remaining_home_events
#    @class_absents = ClassCatlog.includes([:student, :daily_teaching_point]).where(is_present: [nil, false], is_recover: false, is_followed: false).where("created_at >  ? ", Date.today - 2.week)
#    @exam_absents = ExamCatlog.joins([:exam]).includes([:student, :exam]).where(is_present: [nil, false], is_recover: [nil, false], is_followed: false).where("exams.exam_date >  ? ", Date.today - 3.week)
#
#    @unconducted_exams = Exam.where(is_completed: [nil, false])
#    @recent_exams = Exam.where(is_completed: true, is_result_decleared: [nil, false])
#    @todays_exams = Exam.where("exam_date < ? && exam_date > ? ", Date.today + 1.day, Date.today - 1.day)
#    @jkci_classes = JkciClass.all
  end


  def admin_desk
    @class_absents = ClassCatlog.includes([:student, :daily_teaching_point]).where(is_present: [nil, false], is_recover: false, is_followed: false).where("created_at >  ? ", Date.today - 2.week).order("class_catlogs.id desc")
    @exam_absents = ExamCatlog.joins([:exam]).includes([:student, :exam]).order("exam_catlogs.id desc").where(is_present: [nil, false], is_recover: [nil, false], is_followed: false).where("exams.exam_date >  ? ", Date.today - 3.week)
    
    @unconducted_exams = Exam.where(is_completed: [nil, false])
    @recent_exams = Exam.where(is_completed: true, is_result_decleared: [nil, false])
    @todays_exams = Exam.where("exam_date < ? && exam_date > ? ", Date.today + 1.day, Date.today - 1.day)
    @jkci_classes = JkciClass.all
  end
end
