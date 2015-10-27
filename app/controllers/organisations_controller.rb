class OrganisationsController < ApplicationController
  load_and_authorize_resource param_method: :my_sanitizer

  def new
    @organisation  = Organisation.new
  end

  def create
    @organisation  = Organisation.new(params[:organisation])
    user = User.where(email: @organisation.try(:email)).first
    if user
      redirect_to new_user_session_path 
      return
    end
    if @organisation.save 
      redirect_to root_path
    else
      @organisation.send_generated_code if @organisation.errors[:email].include?(' allready registered. Please check email')
      render :new
    end
  end

  def regenerate_organisation_code
    organisation  = Organisation.where(id: params[:id]).first
    organisation.regenerate_organisation_code(params[:mobile])
    respond_to do |format|
      format.json {render json: {success: true}}
    end
  end
  
  def manage_organisation
  end

  private
  
  def my_sanitizer
    #params.permit!
    params.require(:organisation).permit!
  end
end
