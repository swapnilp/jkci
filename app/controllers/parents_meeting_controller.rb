class ParentsMeetingController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource param_method: :my_sanitizer

  
  def index
    @meetings = ParentsMeeting.all.order("id desc").page(params[:page])
  end

  def new
    @meeting = ParentsMeeting.new
    @batches = Batch.active
  end

  def create
    @meeting = ParentsMeeting.new(params[:parents_meeting])
    if @meeting.save
      redirect_to parents_meeting_path(@meeting)
    else
      render :new
    end
  end

  def show
    @meeting = ParentsMeeting.where(id: params[:id]).first
  end
  
  def edit
    @meeting = ParentsMeeting.where(id: params[:id]).first
    @batches = Batch.active
  end

  def update
    @meeting = ParentsMeeting.where(id: params[:id]).first
    if @meeting.update_attributes(params[:parents_meeting])
      redirect_to parents_meeting_path(@meeting)
    else
      render :edit
    end
  end
  
  def destroy
  end

  def sms_send
    meeting = ParentsMeeting.where(id: params[:id]).first
    Delayed::Job.enqueue MeetingSmsSend.new(meeting)
    meeting.update_attributes({sms_sent: true})
    render json: {success: true}
  end

  private
  
  def my_sanitizer
    #params.permit!
    params.require(:parents_meeting).permit!
  end
  
end
