class CoursesController < ApplicationController
  
  def index
    @courses = COURSES
  end

end
