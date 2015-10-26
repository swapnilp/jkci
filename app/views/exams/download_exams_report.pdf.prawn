prawn_document do |pdf|

  pdf.formatted_text [ 
    { text: "Exams", :styles => [:bold], :size => 16 }
  ], align: :center
  
  pdf.define_grid(:columns => 2, :rows => 30, :gutter => 0)
  pdf.grid(1, 0).bounding_box do
    pdf.text "Type-  #{params[:type]}", align: :left  if params[:type].present?
    pdf.text "Status -  #{params[:status]}", align: :left if params[:status].present?
    pdf.text "Class -  #{@jkci_class.try(:class_name)}", align: :left if params[:class_id].present?
  end

 pdf.move_down 5
 pdf.table(@exams_table_format, :column_widths => [30, 30, 115, 80, 35, 60, 60, 70, 40],  :cell_style => { :overflow => :shrink_to_fit, :min_font_size => 6, :height => 17}) do
    row(0).font_style = :bold
    row(0).font_size = 10

    values = cells.columns(1..-1).rows(1..-1)
    
    bad_sales = values.filter do |cell|
      cell.content == 'false'
    end
    
    bad_sales.background_color = "FFAAAA"
  end			     

end