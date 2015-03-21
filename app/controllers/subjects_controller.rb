class SubjectsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource param_method: :my_sanitizer
  
  def index
    @subjects = Subject.all
  end

  def new
    @subject = Subject.new
  end

  def create
    @subject = Subject.new(params[:subject])
    if @subject.save
      redirect_to subjects_path
    else
      render :new
    end
  end

  def show
    @subject = Subject.includes([:chapters]).where(id: params[:id]).first
    @chapters = @subject.chapters.page(params[:page])
    respond_to do |format|
      format.html
      format.json {render json: {success: true, html: render_to_string(:partial => "chapters/chapter.html.erb", :layout => false, locals: {chapters: @chapters}), pagination_html: render_to_string(partial: 'chapters/pagination.html.erb', layout: false, locals: {chapters: @chapters}), css_holder: ".studentsTable tbody"}}
    end
  end

  private
  
  def my_sanitizer
    #params.permit!
    params.require(:student).permit!
  end

end
