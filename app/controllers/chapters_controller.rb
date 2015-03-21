class ChaptersController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource param_method: :my_sanitizer
  
  def index
    @subjects = Subject.all
    @chapters = Chapter.all.order("id desc").page(params[:page])
  end
  
  def new
    @chapter = Chapter.new({subject_id: params[:subject_id]})
  end

  def create
    params.permit!
    chapter = Chapter.new(params[:chapter])
    chapter.save
    redirect_to subject_path(chapter.subject)
  end
  
  def edit
    @chapter = Chapter.where(id: params[:id]).first
  end

  def update
    params.permit!
    chapter = Chapter.where(id: params[:id]).first
    chapter.update_attributes(params[:chapter])
    redirect_to subject_path(chapter.subject)
  end
  
  def filter_chapters
    
  end

  private
  
  def my_sanitizer
    #params.permit!
    params.require(:student).permit!
  end
  
end
