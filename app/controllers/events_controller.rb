class EventsController < ApplicationController
  load_and_authorize_resource
  before_action :authenticate_user!, except: [:index, :show]
  
  def index
    @events = Event.master_events
    @events = @events.where("name like ? or description like ?", "%#{params[:s]}%", "%#{params[:s]}%") if params[:s].present?
    @events = @events.page(params[:page]).per(10)
  end

  def show
    @event = Event.where(id: params[:id]).first
    unless @event.is_public_event
      redirect_to events_path
    end
  end

  def manage_events
    @events = Event.master_events
  end

  def new
    
  end

  def create
  end
end
