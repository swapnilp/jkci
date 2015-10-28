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
  belongs_to :standard
  belongs_to :current_chapter, class_name: "Chapter", foreign_key: "current_chapter_id"
  has_many :sub_classes
  has_many :exam_notifications, through: :exams, source: :notifications
  has_many :dtp_notifications, through: :daily_teaching_points, source: :notifications

  has_many :chapters, through: :subject
  
  #default_scope  {where(is_active: true)} 
  scope :active, -> { where(is_active: true) }

  def manage_students(associate_students, organisation)
    curr_students = self.students.map(&:id)
    removed_students = curr_students - associate_students
    new_std = associate_students -  (curr_students & associate_students)
    self.students.delete(organisation.students.where(id: removed_students))
    self.students << organisation.students.where(id: new_std)
  end
  
  def jk_exams
    Exam.where("(jkci_class_id = ? OR class_ids like '%,?,%') AND organisation_id = ?", self.id, self.id, self.organisation_id)
  end

  def role_exam_notifications(user)
    user_roles = user.roles.select([:name]).map(&:name).map(&:to_sym)
    notification_roles = NOTIFICATION_ROLES.slice(*user_roles).values.flatten
    exam_notifications.where(actions: notification_roles, is_completed: false)
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

  def sub_classes_students(s_c_ids, ex_subject=nil)
    # s_c_ids is array of sub classes
    sub_classes_ids = self.sub_classes.where("id in (?)", s_c_ids).map(&:id)
    sc_string = "sub_class like '%,00,%'"
    sub_classes_ids.each do |sc_id|
      sc_string << " || "# unless sub_classes_ids.first == sc_id
      sc_string << "sub_class like '%,#{sc_id},%'"
    end
    if ex_subject.present? 
      ex_subject.students.joins(:class_students).where(" #{sc_string} and class_students.jkci_class_id = ?", self.id)
    else
      student_ids = self.class_students.where(sc_string).map(&:student_id)
      students.where("students.id in (?)", student_ids)
    end
  end

  def chapters_table_format
    table = [["Chapters", "Points"]]
    chapters = self.subject.chapters
    chapters.each_with_index do |chapter, index|
      table << ["#{chapter.name}", "#{chapter.points_name}"]
    end
    table
  end
  
  def class_students_table_format
    table = [["Id", "Name", "Parent Mobile", "Subjects"]]

    self.students.each_with_index do |student, index|
      table << ["#{index+ 1 }", "#{student.name}", "#{student.p_mobile}", "#{student.subjects.map(&:std_name).join('  |  ')}"]
    end
    table
  end

  def students_table_format(sub_class_ids)
    table = [["Id", "Name", "Parent Mobile", "Is Present", "", "Id", "Name", "Parent Mobile", "Is Present", ""]]
    if sub_class_ids.present?
      c_students = self.sub_classes_students(sub_class_ids.split(','))
    else
      c_students = self.students
    end
    c_students.in_groups_of(2).each do |student_groups|
      table_group = []
      student_groups.each do |student|
        if student
          table_group << ["#{student.id}", "#{student.name}", "#{student.p_mobile}", "", ""] 
        else
          table_group << ["", "", "", "", ""] 
        end
      end
      table << table_group.flatten
    end
    table
  end
  
end
