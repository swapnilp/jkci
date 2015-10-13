class JkciClass < ActiveRecord::Base
  include SendingSms
  belongs_to :teacher
  has_many :class_students
  has_many :students, through: :class_students
  has_many :exams
  has_many :daily_teaching_points
  has_many :class_catlogs
  belongs_to :batch
  belongs_to :subject
  belongs_to :current_chapter, class_name: "Chapter", foreign_key: "current_chapter_id"
  has_many :sub_classes
  has_many :exam_notifications, through: :exams, source: :notifications

  has_many :chapters, through: :subject
  
  default_scope  {where(is_active: true)} 

  def manage_students(associate_students)
    curr_students = self.students.map(&:id)
    removed_students = curr_students - associate_students
    new_std = associate_students -  (curr_students & associate_students)
    self.students.delete(Student.where(id: removed_students))
    self.students << Student.where(id: new_std)
  end
  
  def jk_exams
    Exam.where("jkci_class_id = ? OR class_ids like '%,?,%'", self.id, self.id)
  end

  def role_exam_notifications(user)
    user_roles = user.roles.select([:name]).map(&:name).map(&:to_sym)
    notification_roles = NOTIFICATION_ROLES.slice(*user_roles).values.flatten
    exam_notifications.where(actions: notification_roles, is_completed: false)
  end

  def fill_catlog(present_list, dtp_id, date)
    self.students.each do |student|
     create_catlog(self.id, student.id, dtp_id, date, present_list.map(&:to_i).include?(student.id))
    end
  end

  def add_sub_class_students(students, sub_class)
    class_students.where("student_id in (?)", students.split(',').map(&:to_i)).each do |class_student|
      class_student.add_sub_class(sub_class)
    end
  end

  def remove_sub_class_students(student, sub_class)
    class_students.where("student_id in (?)", student).each do |class_student|
      class_student.remove_sub_class(sub_class.to_i)
    end
  end
    
  def exams_count
    [self.class_name, self.exams.count]
  end
  
  def create_catlog(class_id, student_id, dtp_id, date, is_present)
    class_catlog = ClassCatlog.where({jkci_class_id: class_id, student_id: student_id, daily_teaching_point_id: dtp_id, date: date }).first_or_initialize
    class_catlog.update_attributes({is_present: is_present})
  end

  def sub_classes_students(s_c_ids)
    # s_c_ids is array of sub classes
    sub_classes_ids = sub_classes.where("id in (?)", s_c_ids).map(&:id)
    sc_string = ""
    sub_classes_ids.each do |sc_id|
      sc_string << " || " unless sub_classes_ids.first == sc_id
      sc_string << "sub_class like '%,#{sc_id},%'"
    end
    student_ids = self.class_students.where(sc_string).map(&:student_id)
    students.where("students.id in (?)", student_ids)
  end
end
