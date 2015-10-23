class User::SessionsController < Devise::SessionsController
  skip_before_filter :verify_authenticity_token, only: [:create, :destroy]  
  #after_filter :set_csrf_headers, only: [:create, :destroy]

  protected
  def set_csrf_headers
    cookies['XSRF-TOKEN'] = form_authenticity_token if protect_against_forgery?  
  end
end
