class ApplicationController < ActionController::Base

  #before_action :authenticate_user!
  #before_filter :authentication_check

  before_filter :flicker_photos


  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  
  def authentication_check
    authenticate_or_request_with_http_basic do |user, password|
      user == "jkci" && password == "jkciPassword" 
    end
  end
  
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end
  
  def flicker_photos
    @flicker_photos = Gallery.all.sample(10).map(&:flickers_images).reduce(:merge) || []
  end
  
  #private 
  #def teachers_params
  #  params.require(:teacher).permit(:subject_id, :first_name, :last_name, :mobile, :email, :address)
  #end
end
