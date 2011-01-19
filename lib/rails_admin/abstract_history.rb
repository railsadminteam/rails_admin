module RailsAdmin

  def self.create_update_history(model, object, associations_before, associations_after, modified_associations, old_object, user)
    messages = []

    # determine which fields changed ???
    changed_property_list = []
    properties = model.properties.reject{|property| RailsAdmin::History::IGNORED_ATTRS.include?(property[:name])}

    properties.each do |property|
      property_name = property[:name].to_param
      if old_object.send(property_name) != object.send(property_name)
        changed_property_list << property_name
      end
    end

    model.associations.each do |t|
      assoc = changed_property_list.index(t[:child_key].to_param)
      if assoc
        changed_property_list[assoc] = "associated #{t[:pretty_name]}"
      end
    end

    # Determine if any associations were added or removed
    associations_after.each do |key, current|
      removed_ids = (associations_before[key] - current).map{|m| '#' + m.to_s}
      added_ids = (current - associations_before[key]).map{|m| '#' + m.to_s}
      if removed_ids.any?
        messages << "Removed #{key.to_s.capitalize} #{removed_ids.join(', ')} associations"
      end
      if added_ids.any?
        messages << "Added #{key.to_s.capitalize} #{added_ids.join(', ')} associations"
      end
    end

    modified_associations.uniq.each do |t|
      changed_property_list << "associated #{t}"
    end

    if not changed_property_list.empty?
      messages << "Changed #{changed_property_list.join(", ")}"
    end

    create_history_item(messages, object, model, user) unless messages.empty?
  end

  def self.create_history_item(message, object, abstract_model, user)
    message = message.join(', ') if message.is_a? Array
    date = Time.now
    RailsAdmin::History.create(
                               :message => message,
                               :item => object.id,
                               :table => abstract_model.pretty_name,
                               :username => user ? user.email : "",
                               :month => date.month,
                               :year => date.year
                               )
  end

  def self.history_for_model(model, query, sort, sort_reverse, all, page)
    options = {}
    options[:order] = "created_at DESC"
    options[:conditions] = []
    options[:conditions] << "#{History.connection.quote_column_name(:table)} = ?"
    options[:conditions] << model.pretty_name

    if query
      options[:conditions][0] += " and (#{History.connection.quote_column_name(:message)} LIKE ? or #{History.connection.quote_column_name(:username)} LIKE ?)"
      options[:conditions] << "%#{query}%"
      options[:conditions] << "%#{query}%"
    end

    if sort
      options.delete(:order)
      if sort_reverse == "true"
        options[:order] = "#{sort} desc"
      else
        options[:order] = sort
      end
    end

    if all
      [1, History.find(:all, options)]
    else
      @current_page = (page || 1).to_i
      options.merge!(:page => @current_page, :per_page => 10)
      History.paginated(options)
    end
  end

  def self.history_for_object(model, object, query, sort, sort_reverse)
    options = {}
    options[:order] = "created_at DESC"
    options[:conditions] = []
    options[:conditions] << "#{History.connection.quote_column_name(:table)} = ?"
    options[:conditions] << model.pretty_name

    options[:conditions][0] += " and #{History.connection.quote_column_name(:item)} = ?"
    options[:conditions] << object.id

    if query
      options[:conditions][0] += " and (#{History.connection.quote_column_name(:message)} LIKE ? or #{History.connection.quote_column_name(:username)} LIKE ?)"
      options[:conditions] << "%#{query}%"
      options[:conditions] << "%#{query}%"
    end

    if sort
      options.delete(:order)
      if sort_reverse == "true"
        options[:order] = "#{sort} desc"
      else
        options[:order] = sort
      end
    end

    History.find(:all, options)
  end

  def self.history_latest_summaries
    mstart = 5.month.ago.month
    mstop = Time.now.month

    ystop = Time.now.year
    ystart = 5.month.ago.year

    History.get_history_for_dates(mstart, mstop, ystart, ystop)
  end

  def self.history_for_month(ref, section)
    current_ref = -5 * ref.to_i
    current_diff = current_ref + 5 - (section.to_i + 1)

    current_month = current_diff.month.ago

    return History.find(:all, :conditions => ["month = ? and year = ?", current_month.month, current_month.year]), current_month
  end

  def self.most_recent_history(name)
    History.most_recent name
  end

end
