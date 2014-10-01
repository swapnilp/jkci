class JkciClass < ActiveRecord::Base
  belongs_to :teacher
  has_many :class_students
  has_many :students, through: :class_students
end
