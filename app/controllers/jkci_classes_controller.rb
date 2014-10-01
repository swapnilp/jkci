class JkciClassesController < ApplicationController
  def index
    @jkci_classes = JkciClass.all
  end
  
  def new
    @jkci_class = JkciClass.new
    @teachers = Teacher.all
  end

  def show
    @jkci_class = JkciClass.where(id: params[:id]).first
  end


  def create
    params.permit!
    @jkci_class = JkciClass.new(params[:jkci_class])
    if @jkci_class.save
      redirect_to jkci_classes_path
    end
  end

  def edit
    @jkci_class = JkciClass.where(id: params[:id]).first
    @teachers = Teacher.all
  end
  
  def update
    params.permit!
    jkci_class = JkciClass.where(id: params[:id]).first
    if jkci_class
      if jkci_class.update(params[:jkci_class])
        redirect_to jkci_classes_path
      end
    end
  end
  
  def destroy
    jkci_class = JkciClass.where(id: params[:id]).first
    if jkci_class.destroy
      redirect_to jkci_classes_path
    end
  end
end
