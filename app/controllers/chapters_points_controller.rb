class ChaptersPointsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource param_method: :my_sanitizer
  
  def index
  end

  def new
    @chapter = Chapter.where(params[:chapter_id]).first
    @point = @chapter.chapters_points.build
  end

  def create
    @point = ChaptersPoint.new(params[:chapters_point])
    if @point.save
      redirect_to chapter_path(params[:chapter_id])
    else
      render :new
    end
  end

  def edit
    @chapter = Chapter.where(params[:chapter_id]).first
    @point = @chapter.chapters_points.where(id: params[:id]).first
  end

  def update
    params.permit!
    @point = ChaptersPoint.where(id: params[:id]).first
    if @point.update_attributes(params[:chapters_point])
      redirect_to chapter_path(params[:chapter_id])
    else
      render :edit
    end
  end
  
  private
  
  def my_sanitizer
    #params.permit!
    params.require(:chapters_point).permit!
  end
end
