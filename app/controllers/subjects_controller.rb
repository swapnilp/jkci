class SubjectsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource param_method: :my_sanitizer
  before_action :check_role, only: [:index, :new, :create, :show]
  
  def index
    @subjects = Subject.all
  end

  def new
    @subject = Subject.new({standard_id: params[:standard_id]})
    @standards = Standard.all
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

  def chapters
    subject = Subject.includes([:chapters]).where(id: params[:id]).first
    chapters = subject.chapters
    chapters_points = chapters.first.try(:chapters_points) || []
    respond_to do |format|
      format.json {render json: {success: true, chapters: chapters, chapters_points: chapters_points}}
    end
  end

  private
  
  def my_sanitizer
    #params.permit!
    params.require(:subject).permit!
  end

  def check_role
    raise ActionController::RoutingError.new('Not Found') unless (current_user.has_role?(:admin_clark) ||  current_user.has_role?(:super_admin))
  end

end
