class JkciClass < ActiveRecord::Base
 
  belongs_to :teacher
  has_many :class_students
  has_many :students, through: :class_students
  has_many :exams
  has_many :daily_teaching_points
  has_many :class_catlogs
  belongs_to :batch


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

  def fill_catlog(present_list, dtp_id, date)
    self.students.each do |student|
     create_catlog(self.id, student.id, dtp_id, date, present_list.map(&:to_i).include?(student.id))
    end
  end
  
  def create_catlog(class_id, student_id, dtp_id, date, is_present)
    class_catlog = ClassCatlog.where({jkci_class_id: class_id, student_id: student_id, daily_teaching_point_id: dtp_id, date: date }).first_or_initialize
    class_catlog.update_attributes({is_present: is_present})
  end
end
