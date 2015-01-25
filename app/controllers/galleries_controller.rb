class GalleriesController < ApplicationController
  before_action :authenticate_user!

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
end
