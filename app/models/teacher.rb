class Teacher < ActiveRecord::Base
  #attr_accessor :subject_id, :first_name, :last_name, :mobile, :email, :address
  belongs_to :subject
  
  def name
    "#{first_name} #{last_name}"
  end
end
