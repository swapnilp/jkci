module Charts
  def self.pie_chart(columns, data_set, options)
    data_table = GoogleVisualr::DataTable.new
    columns.each do |datatype, value|
      data_table.new_column(datatype, value)
    end

    # Add Rows and Values
    data_table.add_rows(data_set)
    option = { width: 400, height: 240, is3D: true}.merge(options)
    @chart = GoogleVisualr::Interactive::PieChart.new(data_table, option)
  end
end
