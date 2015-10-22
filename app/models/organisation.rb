class Organisation < ActiveRecord::Base

  validates :email, presence: true, uniqueness: {
    message: " allready registered. Please check email" }, format: { with: /\b[A-Z0-9._%a-z\-]+@(?:[A-Z0-9a-z\-]+\.)+[A-Za-z]{2,4}\z/}
  validates :name, presence: true
  validates :mobile, presence: true, format: { with: /\d{10}/, message: "should be 10 digit"}

  after_create :generate_email_code


  def generate_email_code
    e_code = (0...50).map { ('a'..'z').to_a[rand(26)] }.join
    m_code = (0...7).map { ('a'..'z').to_a[rand(26)] }.join
    update_attributes({email_code: e_code, mobile_code: m_code})
    OrganisationMailer.registation_user(self).deliver
  end
end
