class OrganisationsController < ApplicationController
  load_and_authorize_resource param_method: :my_sanitizer
  before_action :authenticate_user!, only: [:manage_organisation, :add_cources, :add_remaining_cources]

  def new
    @org  = Organisation.new
  end

  def create
    @org  = Organisation.new(params[:organisation])
    user = User.where(email: @org.try(:email)).first
    if user
      redirect_to new_user_session_path 
      return
    end
    if @org.save 
      redirect_to root_path
    else
      @org.send_generated_code if @org.errors[:email].include?(' allready registered. Please check email')
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
    @standards = @organisation.standards
  end
  
  def manage_courses
    @standards = @organisation.standards
  end

  def manage_users
  end

  def remaining_cources
    raise ActionController::RoutingError.new('Not Found') unless @organisation.id == params[:id].to_i
    standards = Standard.select([:id, :name, :stream]).where("id not in (?)", ([0] + @organisation.standards.map(&:id)))
    respond_to do |format|
      format.json {render json: {success: true, standards: standards.as_json}}
    end
  end

  def add_remaining_cources
    raise ActionController::RoutingError.new('Not Found') unless @organisation.id == params[:id].to_i
    standards = Standard.select([:id, :name, :stream]).where("id in (?)", (params[:courses].split(',').map(&:to_i) + [0]))
    standards = standards.where("id not in (?)", (@organisation.standards.map(&:id) + [0]) )
    @organisation.standards << standards
    respond_to do |format|
      format.json {render json: {success: true}}
    end
  end

  private
  
  def my_sanitizer
    #params.permit!
    params.require(:organisation).permit!
  end
end
