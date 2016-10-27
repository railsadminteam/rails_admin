module FilterBoxSelectors
  def checkbox_filter_selector(association_name, model)
    "input[name='f[#{association_name}][1][v][]'][value='#{model.id}']"
  end

  def text_filter_selector(association_name)
    "input[name='f[#{association_name}][1][v]'][type='text']"
  end

  def select_filter_selector(association_name)
    "select[name='f[#{association_name}][1][v]']"
  end
end
