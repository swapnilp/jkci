class JkciClass < ActiveRecord::Base
  belongs_to :teacher
  has_many :class_students
  has_many :students, through: :class_students
  has_many :exams
  has_many :daily_teaching_points


  def manage_students(associate_students)
    curr_students = self.students.map(&:id)
    removed_students = curr_students - associate_students
    new_std = associate_students -  (curr_students & associate_students)
    self.students.delete(Student.where(id: removed_students))
    self.students << Student.where(id: new_std)
    
  end
end
