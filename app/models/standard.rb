class Standard < ActiveRecord::Base
  has_many :subjects
  has_many :students
  
  scope :active, -> {where(is_active: true).order("id DESC")}

  def std_name
    "#{name}-#{stream}"
  end
end
