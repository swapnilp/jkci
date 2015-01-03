class ApplicationController < ActionController::Base

  #before_action :authenticate_user!
  #before_filter :authentication_check

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  
  def authentication_check
    authenticate_or_request_with_http_basic do |user, password|
      user == "user" && password == "password" 
    end
  end
  
  #private 
  #def teachers_params
  #  params.require(:teacher).permit(:subject_id, :first_name, :last_name, :mobile, :email, :address)
  #end
end
