prawn_document do |pdf|

  pdf.formatted_text [ 
    { text: "#{@exam.id} - #{@exam.name}", :styles => [:bold], :size => 16 }
  ], align: :center

  pdf.define_grid(:columns => 2, :rows => 30, :gutter => 0)
  pdf.grid(1, 0).bounding_box do
    pdf.text "Class -  #{@exam.jkci_class.class_name}", align: :left  
    pdf.text "Marks -  #{@exam.marks}", align: :left
  end
  pdf.grid(1, 1).bounding_box do
    pdf.text "Date -  #{@exam.exam_date.to_date}", align: :right
    pdf.text "Exam Type -  #{@exam.exam_type}", align: :right  
  end

  
  
 

 pdf.move_down 5
 pdf.table(@exam_catlogs, :column_widths => [35, 185, 80, 80, 60, 55],  :cell_style => { :overflow => :shrink_to_fit, :min_font_size => 6, :height => 17}) do
    row(0).font_style = :bold
    row(0).font_size = 10

    values = cells.columns(1..-1).rows(1..-1)
    
    bad_sales = values.filter do |cell|
      cell.content == 'false'
    end
    
    bad_sales.background_color = "FFAAAA"
  end			     

end