module ListSelectors

  # match td title attribute
  def list_item_with_title(title)
    "td[title='#{title}']"
  end

end