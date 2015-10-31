class OrganisationsController < ApplicationController
  load_and_authorize_resource param_method: :my_sanitizer, except: [:new_user]
  before_action :authenticate_user!, only: [:manage_organisation, 
                                            :add_cources, :add_remaining_cources, :new_user, 
                                            :remaining_cources, :add_remaining_cources, :delete_users, 
                                            :edit_password, :update_password]

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

  def new_users
    @user = @organisation.users.clarks.build
  end

  def create_users
    @user = @organisation.users.clarks.build(user_params)
    if @user.save
      @user.add_role :clark
      redirect_to manage_organisation_path(@organisation)
    else
      render :new_users
    end
  end

  def edit_password
    @user = @organisation.users.clarks.where(id: params[:user_id]).first
  end

  def update_password
    @user = @organisation.users.clarks.where(id: params[:user_id]).first
    unless @user.nil?
      @user.errors.add(:password_confirmation, "password must match.") if update_password_params[:password] != update_password_params[:password_confirmation]
      
      if !@user.errors.any? && @user.update_attributes(update_password_params)
        redirect_to manage_organisation_path(@organisation)
      else
        render :edit_password
      end
    else
      redirect_to manage_organisation_path(@organisation)
    end
  end
  
  def delete_users
    user = @organisation.users.clarks.where(id: params[:user_id]).first
    if user
      user.roles = []
      user.destroy 
    end
    redirect_to manage_organisation_path(@organisation)
  end
  
  def disable_users
    user = @organisation.users.clarks.where(id: params[:user_id]).first
    user.update_attributes({is_enable: false})
    redirect_to manage_organisation_path(@organisation)
  end

  def enable_users
    user = @organisation.users.clarks.where(id: params[:user_id]).first
    user.update_attributes({is_enable: true})
    redirect_to manage_organisation_path(@organisation)
  end

  def manage_roles
    @user = @organisation.users.clarks.where(id: params[:user_id]).first
  end

  def update_roles
    user = @organisation.users.clarks.where(id: params[:user_id]).first
    user.manage_clark_roles(params[:role])
    redirect_to manage_organisation_path(@organisation)
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
    @users = @organisation.users.clarks.select([:id, :email, :organisation_id, :is_enable])
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

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :salt, :encrypted_password)
  end

  def update_password_params
    params.require(:user).permit(:password, :password_confirmation, :salt, :encrypted_password)
  end
end
