class ApplicationController < ActionController::Base
  #load_and_authorize_resource 

  #before_action :authenticate_user!
  #before_filter :authentication_check

  before_filter :flicker_photos
  before_action :configure_permitted_parameters, if: :devise_controller?

  #before_filter :get_organisation, if: current_user.present?
  
  def authenticate_user!
    super
    @organisation = current_user.organisation
  end
  
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  before_filter :set_cache_buster
  
  def set_cache_buster
    response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
  end
  
  
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


  protected
  
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:username, :email, :password, :password_confirmation, :remember_me) }
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:login, :username, :email, :password, :remember_me) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:username, :email, :password, :password_confirmation, :current_password) }
  end
  
  #private 
  #def teachers_params
  #  params.require(:teacher).permit(:subject_id, :first_name, :last_name, :mobile, :email, :address)
  #end
end
