class AlbumsController < ApplicationController
  load_and_authorize_resource param_method: :my_sanitizer
  before_action :authenticate_user!
  def index
    @albums = Album.all.order("id desc").page(params[:page])
    respond_to do |format|
      format.html
      format.json {render json: {success: true, html: render_to_string(:partial => "album.html.erb", :layout => false, locals: {albums: @albums}), pagination_html:  render_to_string(partial: 'pagination.html.erb', layout: false, locals: {albums: @albums}), css_holder: ".albumsTable tbody"}}
    end
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
    @albums = Album.all.page(params[:page])
    respond_to do |format|
      format.html
      format.json {render json: {success: true, html: render_to_string(:partial => "album.html.erb", :layout => false, locals: {albums: @albums}), pagination_html:  render_to_string(partial: 'pagination.html.erb', layout: false, locals: {albums: @albums}), css_holder: ".albumsTable tbody"}}
    end    
  end

  private
  
  def my_sanitizer
    #params.permit!
    params.require(:album).permit!
  end
end
