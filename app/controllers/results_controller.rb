class ResultsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]

  load_and_authorize_resource :class => "BatchResult", except: [:edit, :create, :destroy, :update]
  load_and_authorize_resource :class => "Result", only: [:edit, :create, :destroy, :update]
  
  load_and_authorize_resource param_method: :my_sanitizer

  def index
    @results = BatchResult.published.page(params[:page])
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
    result = Result.new(result_params)
    if result.save
      render json: {success: true, is_new: true, html: render_to_string(:partial => "result.html.erb", :layout => false, locals: {result: result})}
    else
      render json: {success: false}
    end
  end
  
  def show
    @batch_result = BatchResult.where(id: params[:id]).first
    @results = @batch_result.published_results
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

  private
  
  def my_sanitizer
    #params.permit!
    params.require(:result).permit!
  end
  
  def result_params
    params.require(:result).permit(:batch_result_id, :name, :marks, :stream, :college, :rank, :disp_rank, :student_img)
  end

end

