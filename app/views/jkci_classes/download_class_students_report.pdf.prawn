prawn_document do |pdf|

  pdf.formatted_text [ 
    { text: "#{@jkci_class.id} - #{@jkci_class.class_name}", :styles => [:bold], :size => 16 }
  ], align: :center

  pdf.move_down(10)

  @students.each do |student|
  pdf.move_down(10)
  pdf.formatted_text [ 
    { text: "#{student.name}", :styles => [:bold], :size => 16 }
  ], align: :center
  pdf.move_down(10)
  pdf.table(student.exam_report_table_format, :column_widths => [20, 60, 65, 65],  :cell_style => { :overflow => :shrink_to_fit, :min_font_size => 6, :height => 17}) do
    row(0).font_style = :bold
    row(0).size = 12
  end			       
  end
end