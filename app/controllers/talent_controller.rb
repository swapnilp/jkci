class TalentController < ApplicationController

  def new_talent2015
    @talent = Talent2015.new
  end

  def create_talent2015
    params.require(:talent2015).permit!
    talent = Talent2015.new(params[:talent2015])
    if talent.save
      redirect_to root_path
    else
      redirect_to root_path
    end
  end
  
end
