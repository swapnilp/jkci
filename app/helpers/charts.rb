module Charts
  def self.pie_chart(columns, data_set, options)
    data_table = GoogleVisualr::DataTable.new
    columns.each do |datatype, value|
      data_table.new_column(datatype, value)
    end

    # Add Rows and Values
    data_table.add_rows(data_set)
    option = { width: "100%", height: 240, is3D: true}.merge(options)
    @chart = GoogleVisualr::Interactive::PieChart.new(data_table, option)
  end

  def self.line_chart(columns, data_set, options)
    data_table = GoogleVisualr::DataTable.new
    data_table.new_column('string', 'week')
    columns.each do | value|
      data_table.new_column('number', value)
    end
    data_table.add_rows(data_set)
    opts   = { :width => "100%", :height => 240, :title => 'Weekly Performance', :legend => 'bottom' }.merge(options)
    @chart = GoogleVisualr::Interactive::LineChart.new(data_table, opts)
  end
end
