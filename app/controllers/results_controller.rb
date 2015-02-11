class ResultsController < ApplicationController
  def index
    
  end
  
  def new
    batch_result = BatchResult.where(id: params[:batch_id]).first
    result = batch_result.results.new
    respond_to do |format|
      format.html
      format.json {render json: {success: true, html: render_to_string(:partial => "form.html.erb", :layout => false, locals: {result: result})}}
    end
  end
  
  def create
    params.permit!
    result = Result.new(params[:result])
    if result.save
      render json: {success: true, is_new: true, html: render_to_string(:partial => "result.html.erb", :layout => false, locals: {result: result})}
    else
      render json: {success: false}
    end
  end
  
  def show

  end

  def edit
    result = Result.where(id: params[:id]).first
    respond_to do |format|
      format.html
      format.json {render json: {success: true, html: render_to_string(:partial => "form.html.erb", :layout => false, locals: {result: result})}}
    end
  end
  
  def update
    params.permit!
    result = Result.where(id: params[:id]).first
    if result
      result.update_attributes(params[:result])
    end
    render json: {success: true, cssHolder: ".batchResult_#{result.id}", html: render_to_string(:partial => "result.html.erb", :layout => false, locals: {result: result})}
  end

  def destroy
    result = Result.where(id: params[:id]).first
    if result && result.destroy
      render json: {success: true}
    else
      render json: {success: false}
    end
  end

  def add_result_photo
    params.permit!
    attachment = ResultsPhoto.new(params[:results_photo])
    if attachment.save     
      respond_to do |format|
        format.json {render json: {success: true, id: attachment.id, url: attachment.image.url(:thumb)}}
      end
    else
      Rails.logger.info attachment.errors.inspect
      respond_to do |format|
        format.json {render json: {success: false, msg: attachment.errors.messages.values.first.first}}
      end
    end
  end
end

