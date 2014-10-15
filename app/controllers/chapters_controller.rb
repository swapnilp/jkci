class ChaptersController < ApplicationController
  
  def index
    @subjects = Subject.all
    @chapters = Chapter.all.order("id desc").paginate(:page => params[:page])
  end
  
  def new
  end

  def create
  end
  
  def edit
  end

  def update
  end
  
  def filter_chapters
    
  end
end
