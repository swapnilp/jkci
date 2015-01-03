class SmsSentsController < ApplicationController
  before_action :authenticate_user!
  include SendingSms
  
  def index
    @sms_logs = SmsSent.all.order("id desc").paginate(:page => params[:page])
  end
  
  def check_balance
    @balance = SendingSms.new.deliver_sms(URI::encode("https://www.txtguru.in/imobile/balancecheckapi.php?&username=#{SMSUNAME}&password=#{SMSUPASSWORD}"))

    render json: {success: true, balance: @balance}
  end
end
