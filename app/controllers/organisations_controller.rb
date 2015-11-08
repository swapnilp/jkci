class OrganisationsController < ApplicationController
  load_and_authorize_resource param_method: :my_sanitizer, except: [:new_user]
  #before_action :authenticate_user!, only: [:manage_organisation, :manage_roles, :update_roles, :manage_courses
  #                                          :add_cources, :add_remaining_cources, :new_user,:disable_users, :enable_users 
  #                                          :remaining_cources, :add_remaining_cources, :delete_users, 
  #                                          :edit_password, :update_password, :launch_sub_organisation]
  
  before_action :authenticate_user!, except: [:new, :create, :regenerate_organisation_code]

  def new
    @org  = Organisation.new
  end

  def create
    @org  = Organisation.new(organisation_params)
    users = User.where(email: @org.try(:email))
    if users.present? && users.map(&:organisation).map(&:root?).include?(true)
      redirect_to new_organisation_path , flash: {success: false, notice: "Email Already used for organisation Please try with another email."} 
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
      @user.add_clark_roles
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
    @standards = @organisation.standards.select("standards.*, organisation_standards.is_assigned_to_other, organisation_standards.assigned_organisation_id")
    @users = @organisation.users.clarks.select([:id, :email, :organisation_id, :is_enable])
    @sub_organisations = @organisation.descendants
  end
  
  def manage_courses
    @standards = @organisation.standards
  end

  def manage_users
  end

  def remaining_cources
    raise ActionController::RoutingError.new('Not Found') if @organisation.id != params[:id].to_i && !@organisation.root?
    standards = Standard.select([:id, :name, :stream]).where("id not in (?)", ([0] + @organisation.standards.map(&:id)))
    respond_to do |format|
      format.json {render json: {success: true, standards: standards.as_json}}
    end
  end

  def add_remaining_cources
    raise ActionController::RoutingError.new('Not Found') if @organisation.id != params[:id].to_i && !@organisation.root?
    @organisation.manage_standards(params[:courses])
    
    respond_to do |format|
      format.json {render json: {success: true}}
    end
  end

  def launch_sub_organisation
    @org = @organisation.sub_organisations.build
    @standard_ids = params[:standards]
    @standards = @organisation.standards.where(id: params[:standards].split(','))
  end

  def create_sub_organisation
    @org  = Organisation.new(organisation_params)
    if @org.save 
      standard_ids = params[:standards].split(',').map(&:to_i)
      standards = Standard.where(id: standard_ids)
      standards.each do |standard|
        @organisation.launch_sub_organisation(@org.id, standard)
      end
      redirect_to manage_organisation_path(@organisation), flash: {success: true, notice: "Sub Organisation has been created."} 
    else
      @standard_ids = params[:standards]
      @standards = @organisation.standards.where(id: params[:standards].split(','))
      @org.send_generated_code if @org.errors[:email].include?(' allready registered. Please check email Or Use another')
      render :launch_sub_organisation
    end
  end
  
  def pull_back_standard
    standard = @organisation.standards.where(id: params[:standard_id]).first
    if standard
      @organisation.pull_back_standard(standard)
      redirect_to manage_organisation_path(@organisation) , flash: {success: true, notice: "course pull back successfully."} 
    else
      redirect_to manage_organisation_path(@organisation), flash: {success: false, notice: "Ops! Something went wrong."} 
    end
  end 

  def pull_back_organisation
    if @organisation.descendant_ids.include?(params[:old_organisation].to_i)
      old_org = Organisation.where(id: params[:old_organisation]).first 
    end
    if old_org
      @organisation.pull_back_organisation(old_org)
      redirect_to manage_organisation_path(@organisation) , flash: {success: true, notice: "course pull back successfully."} 
    else
      redirect_to manage_organisation_path(@organisation), flash: {success: false, notice: "Ops! Something went wrong."} 
    end
  end

  def organisation_descendants
    organisations = @organisation.descendants.select([:id, :name, :email, :mobile])
    respond_to do |format|
      format.json {render json: {success: true, organisations: organisations.as_json}}
    end
  end
  
  def switch_organisation_standard
    success = @organisation.switch_organisation(params[:old_organisation_id], params[:new_organisation_id], params[:standard_id])
    respond_to do |format|
      format.json {render json: {success: success}}
    end
    
  end

  private
  
  def my_sanitizer
    #params.permit!
    params.require(:organisation).permit!
  end

  def organisation_params
    params.require(:organisation).permit(:parent_id, :name, :email, :mobile)
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :salt, :encrypted_password)
  end

  def update_password_params
    params.require(:user).permit(:password, :password_confirmation, :salt, :encrypted_password)
  end
end
