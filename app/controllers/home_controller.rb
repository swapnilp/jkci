class HomeController < ApplicationController
  load_and_authorize_resource :class => "Gallery", only: [:index]
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
  
  def our_facilities
  end

  def timetable
    
  end


  def admin_desk
    #@class_absents = ClassCatlog.includes([:student, :daily_teaching_point]).where(is_present: [false], is_recover: false, is_followed: false).where("created_at >  ? ", Date.today - 3.day).order("class_catlogs.id desc")
   # @exam_absents = ExamCatlog.joins([:exam]).includes([:student, :exam]).order("exam_catlogs.id desc").where(is_present: [false], is_recover: [nil, false], is_followed: false).where("exams.exam_date >  ? ", Date.today - 3.day)
    
    @unconducted_exams = @organisation.exams.unconducted_exams
    #@recent_exams = Exam.where(is_completed: true, is_result_decleared: [nil, false])
    @upcomming_exams = @organisation.exams.upcomming_exams
    @todays_exams = @organisation.exams.todays_exams
    @jkci_classes = @organisation.jkci_classes.active
    @sub_organisation_classes = @organisation.sub_organisation_classes
    @unpublished_exams = @organisation.exams.unpublished_exams
    @default_students = @organisation.students.default_students(@organisation.absent_days)
    if  @jkci_classes.present?
    @chart = Charts.pie_chart([['string', 'Class Name'], ['number', 'Exams']], @organisation.jkci_classes.active.map(&:exams_count), {title: 'Class Exams'})
    end
    if @organisation.has_children?
      @sub_organisaiton_charts = Charts.pie_chart([['string', 'Organisation'], ['number', 'Default Students']], @organisation.subtree.map(&:default_students_count), {title: 'Organisaiton Default Students'})
    end
    if @organisation.has_children?
      weekly_performances = @organisation.subtree_performance_by_week
      @sub_organisaiton_performance = Charts.line_chart(weekly_performances[0], weekly_performances[1], {title: 'Organisation Performances'})
    end
    standards_performances = @organisation.standards_performance_by_week
    @standards_performance = Charts.line_chart(standards_performances[0], standards_performances[1], {title: 'Standards Performances'})
  end
end
