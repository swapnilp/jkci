class Standard < ActiveRecord::Base
  has_many :subjects
  
  def std_name
    "#{name}-#{stream}"
  end
end
