class AlbumsController < ApplicationController

  def index
    @albums = Album.all
  end

  def new
    @album = Abbum.new
  end

  def create
    params.permit!
    album = Album.new(params[:album])
    if album.save
      redirect_to albums_path
    end
  end
  
  def show
  end

  def edit
  end

  def update
  end
  
  def destroy
  end

end
