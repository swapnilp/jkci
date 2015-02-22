class BatchResultsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource param_method: :my_sanitizer

  def index
    @batch_results = BatchResult.all.page(params[:page])
  end
  
  def new
    @batch_result = BatchResult.new
  end
  
  def create
    params.permit!
    batch_result = BatchResult.new(params[:batch_result])
    if batch_result.save
      redirect_to batch_result_path(batch_result)
    end
  end
  
  def show
    @batch_result = BatchResult.includes(:results).where(id: params[:id]).first
  end

  def edit
    @batch_result = BatchResult.where(id: params[:id]).first
  end

  def update
    params.permit!
    @batch_result = BatchResult.where(id: params[:id]).first
    if @batch_result && @batch_result.update(params[:batch_result])
      redirect_to batch_results_path
    end
  end

  private
  
  def my_sanitizer
    #params.permit!
    params.require(:batch_result).permit!
  end
end
