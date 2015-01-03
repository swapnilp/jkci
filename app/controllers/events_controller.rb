class EventsController < ApplicationController

  def index
    @events = Event.remaining_events
  end

  def show
    @event = Event.where(id: params[:id]).first
    unless @event.is_public_event
      redirect_to events_path
    end
  end
  

end
