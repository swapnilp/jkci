class StandardsController < ApplicationController
  def index
    @standards = Standard.all
  end

  def new
    @standard = Standard.new
  end

  def create
    @standard = Standard.new(params[:standard])
    if @standard.save
      redirect_to standards_path
    else
      render :new
    end
  end
  
  def show
    @standard = Standard.where(id: params[:id]).first
    @subjects = @standard.subjects
  end

  def edit
    @standard = Standard.where(id: params[:id]).first
  end

  def update
    @standard = Standard.where(id: params[:id]).first
    if @standard.update_attributes(params[:standard])
      redirect_to standard_path(@standard)
    else
      render :edit
    end
  end
end
