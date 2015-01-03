class ChaptersController < ApplicationController
  before_action :authenticate_user!

  def index
    @subjects = Subject.all
    @chapters = Chapter.all.order("id desc").paginate(:page => params[:page])
  end
  
  def new
    @subjects = Subject.all
    @chapter = Chapter.new
  end

  def create
    params.permit!
    chapter = Chapter.new(params[:chapter])
    chapter.save
    redirect_to chapters_path
  end
  
  def edit
    @subjects = Subject.all
    @chapter = Chapter.where(id: params[:id]).first
  end

  def update
    params.permit!
    chapter = Chapter.where(id: params[:id]).first
    chapter.update_attributes(params[:chapter])
    redirect_to chapters_path #chapter_path(chapter)
  end
  
  def filter_chapters
    
  end
end
