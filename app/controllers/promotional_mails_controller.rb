class PromotionalMailsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource param_method: :my_sanitizer

  def index
    @mails = PromotionalMail.select([:id, :mails, :msg, :subject, :created_at]).order("id desc").page(params[:page])
    respond_to do |format|
      format.html
      format.json {render json: {success: true, html: render_to_string(:partial => "mail.html.erb", :layout => false, locals: {mails: @mails}), pagination_html: render_to_string(partial: 'pagination.html.erb', layout: false, locals: {mails: @mails}), css_holder: ".studentsTable tbody"}}
    end
  end

  def new
    @mail = PromotionalMail.new
  end
  
  def create
    params.permit!
    mail = PromotionalMail.new(params[:promotional_mail])
    if mail.save
      Delayed::Job.enqueue CustomMailQueue.new(mail) #ClassAbsentSms.new(DailyTeachingPoint.last)
      redirect_to promotional_mails_path
    end
  end
  
  def show
    @mail = PromotionalMail.where(id: params[:id]).first
  end
  
  private
  
  def my_sanitizer
    #params.permit!
    params.require(:promotional_mail).permit!
  end

end
