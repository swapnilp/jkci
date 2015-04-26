class GalleriesController < ApplicationController
  load_and_authorize_resource :class => "Album", only: [:index, :show]
  load_and_authorize_resource :class => "Gallery", only: [:create, :destroy], param_method: :my_sanitizer


  before_action :authenticate_user!, except: [:index, :show]
  
  def index
    @albums = Album.includes(:galleries).all.order("id desc").page(params[:page])
  end

  def show
    @album = Album.includes([:galleries]).where(id: params[:id]).first
  end


  def create
    params.permit!
    attachment = Gallery.new(params[:gallery])
    attachment.album_id= params[:album_id]
    if attachment.save     
      respond_to do |format|
        format.json {render json: {success: true, id: attachment.id, html: render_to_string(:partial => "/albums/image.html.erb", :layout => false, locals: {image: attachment})}}
      end
    else
      Rails.logger.info attachment.errors.inspect
      respond_to do |format|
        format.json {render json: {success: false, msg: attachment.errors.messages.values.first.first}}
      end
    end
  end

  def destroy
    params.permit!
    attachment = Gallery.where(id: params[:id]).first
    attachment.image = nil
    respond_to do |format|
      if attachment.destroy
        format.json {render json: {success: true}}
      else
        format.json {render json: {success: false}}
      end
    end
  end

  private
  
  def my_sanitizer
    #params.permit!
    params.require(:gallery).permit!
  end

end
