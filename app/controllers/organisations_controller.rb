class OrganisationsController < ApplicationController
  load_and_authorize_resource param_method: :my_sanitizer

  def new
    @organisation  = Organisation.new
  end

  def create
    @organisation  = Organisation.new(params[:organisation])
    if @organisation.save 
      redirect_to root_path
    else
      render :new
    end
  end

  private
  
  def my_sanitizer
    #params.permit!
    params.require(:organisation).permit!
  end
end
