def fill_in_multiline_editor(id, with:)
  # ds_class_name = find(:xpath, "//*[@id='#{id}_multiline_input_entity']", visible: false)[:name].split('[').first
  # find(:xpath, "//*[@id='#{id}_multiline_input_#{ds_class_name}']", visible: false).set(with)
  # find(:xpath, "//*[@id='#{find_multiline_editor(id)[:input]}']", visible: false).set(with)
  # find(:xpath, "//*[@id='#{id}']", visible: false).set(with)
  # find(:xpath, "//*[@id='#{find_trix_editor(id)[:input]}']", visible: false).set(with)
  find(:xpath, "//*[@id='#{find_multiline_editor(id)[:input]}']", visible: false).set(with)
  # puts "============= fill_in_multiline_editor =================="
  # puts "with: #{with}"
  # puts "mled content: #{find_multiline_editor(id).root.innerHTML}"
  # puts "mled content: #{find_multiline_editor(id).text}"
  # raise "STOPPPP"
end

def find_multiline_editor(id)
  # find(:xpath, "//trix-editor[@id='#{id}']", visible: false)
  find(:xpath, "//*[@id='#{id}']", visible: false)
end

