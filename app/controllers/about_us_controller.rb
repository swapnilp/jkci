class AboutUsController < ApplicationController
  load_and_authorize_resource :class => "Gallery" , only: [:index]

  def index
  end

  def contact_us
    authorize! :roll, :contact_us
    
  end
  
end
