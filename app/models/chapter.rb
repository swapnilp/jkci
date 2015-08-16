class Chapter < ActiveRecord::Base
  belongs_to :subject
  has_many :chapters_points
  has_many :current_classes, class_name: "JkciClass", foreign_key: "current_chapter_id"
end
