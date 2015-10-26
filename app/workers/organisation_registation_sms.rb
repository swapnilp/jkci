class OrganisationRegistationSms < Struct.new(:organisation)
  include SendingSms
  def perform
    send_sms(organisation)
  end

  def send_sms(organisation)
    message = "One time password is #{organisation.mobile_code}  for #{organisation.name} registation on EraCord. Please do not share OTP to any one for securiety reason."
    url = "https://www.txtguru.in/imobile/api.php?username=#{SMSUNAME}&password=#{SMSUPASSWORD}&source=update&dmobile=91#{organisation.mobile}&message=#{message}"
    deliver_sms(URI::encode(url))
    
  end
end
#Delayed::Job.enqueue OrganisationRegistationSms.new(DailyTeachingPoint.last)