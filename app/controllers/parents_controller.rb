class ParentsController < ApplicationController
  #load_and_authorize_resource :class => false, :class => "Student"
  before_action :authenticate_user!
  load_and_authorize_resource param_method: :my_sanitizer, class: "User"

  def index
    @parents = User.where(role: "parent").order("id desc").page(params[:page])
  end

  def new
    @parent = User.new
  end

  def create
    @parent = User.new(params[:user])
    @parent.role = "parent"
    if @parent.save
      redirect_to parent_path(@parent) 
    else
      p @parent.errors
      render :new
    end
  end

  def show
    @parent = User.where(id: params[:id]).first
  end


  def edit
    #@parent = User.where(id: params[:id]).first
  end

  def update
    #parent = User.where(id: params[:id]).first
    #parent.update_attributes({})
  end

  def destroy
  end

  
  def my_sanitizer
    #params.permit!
    params.require(:user).permit!
  end  
end

