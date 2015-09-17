class ParentsListController < ApplicationController
  
  def index
    @jkci_classes = JkciClass.all
  end
  
  def get_parent_list
    jkci_classes  = JkciClass.where("id in (?)", params[:jkci_class_ids].split(','))
    p jkci_classes
    students = jkci_classes.map{| jkci| jkci.students.select([:id, :parent_name, :p_mobile])}.uniq.flatten
    p students
    respond_to do |format|
      format.json {render json: {success: true, students: students}}
    end
  end
  
  def generate_pdf
    jkci_classes  = JkciClass.where("id in (?)", params[:jkci_class_ids].split(','))
    @students = jkci_classes.map{| jkci| jkci.students.select([:id, :parent_name, :p_mobile])}.uniq.flatten
  end
  
end
