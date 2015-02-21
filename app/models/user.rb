class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def admin?
    return role == 'admin'
  end

  def staff?
    return role == 'staff'
  end

  def clark?
    return role == 'clark'
  end

  def parent?
    return role == 'parent'
  end
end
