class AboutUsController < ApplicationController
  load_and_authorize_resource :class => false, :class => "Gallery"  
  def index
  end

  def contact_us
    
  end
  
end
