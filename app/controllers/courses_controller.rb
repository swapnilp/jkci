class CoursesController < ApplicationController
  load_and_authorize_resource :class => "Gallery"  
  def index
    @courses = COURSES
  end

end
