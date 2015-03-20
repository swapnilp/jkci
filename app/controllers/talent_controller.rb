class TalentController < ApplicationController
  load_and_authorize_resource :class => false, :class => "Talent2015", only: [:index, :download_talent_2015]
  def index
    @students = Talent2015.all.page(params[:page])
    respond_to do |format|
      format.html
      format.json {render json: {success: true, html: render_to_string(:partial => "student.html.erb", :layout => false, locals: {students: @students}), pagination_html: render_to_string(partial: 'pagination.html.erb', layout: false, locals: {students: @students}), css_holder: ".studentsTable tbody"}}
    end
  end

  def new_talent2015
    @talent = Talent2015.new
  end

  def create_talent2015
    params.require(:talent2015).permit!
    talent = Talent2015.new(params[:talent2015])
    if talent.save
      redirect_to root_path, flash: {success: true, notice: "Thank you for registation. We'll get back to you as soon as possible."} 
    else
      redirect_to root_path, flash: {success: false, notice: "Oops!! Something went wrong. Please try again."} 
    end
  end

  def download_talent_2015
    @students = Talent2015.all
    respond_to do |format|
      format.xls { send_data @students.to_csv(col_sep: "\t"), filename: "#{Date.today}_talent2015.xls" }
    end
  end
  
end
