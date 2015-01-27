class AlbumsController < ApplicationController

  def index
    @albums = Album.all.order("id desc").paginate(:page => params[:page])
  end

  def new
    @album = Album.new
  end

  def create
    params.permit!
    album = Album.new(params[:album])
    if album.save
      redirect_to album_path(album)
    end
  end
  
  def show
    @album = Album.where(id: params[:id]).first
    @images = @album.galleries
  end

  def edit
    @album = Album.where(id: params[:id]).first
  end

  def update
    params.permit!
    album = Album.where(id: params[:id]).first
    if album.present? && album.update_attributes(params[:album])
      redirect_to album_path(album)
    end
  end
  
  def destroy
  end
  
  def manage_albums
    @albums = Album.all
  end
end
