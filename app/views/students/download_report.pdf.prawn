prawn_document do |pdf|

  pdf.formatted_text [ 
    { text: "#{@student.id} - #{@student.name}", :styles => [:bold], :size => 18 }
  ], align: :center
  pdf.pad_bottom(10) { pdf.text "Parent Mobile -  #{@student.p_mobile}", align: :right }
  pdf.stroke_horizontal_rule

  pdf.move_down 10
  pdf.formatted_text [ 
    { text: "Exams", :styles => [:bold], :size => 18 }
  ], align: :left

  pdf.table(@exam_catlogs, :column_widths => [35, 160, 55, 80, 60, 50, 45, 35],  :cell_style => { :overflow => :shrink_to_fit, :min_font_size => 8, :height => 18 }) do
    row(0).font_style = :bold

    values = cells.columns(1..-1).rows(1..-1)
    
    bad_sales = values.filter do |cell|
      cell.content == 'false'
    end
    
    bad_sales.background_color = "FFAAAA"
  end			   

end