class RailsAdmin::History < ActiveRecord::Base
  self.table_name = :rails_admin_histories

  IGNORED_ATTRS = Set[:id, :created_at, :created_on, :deleted_at, :updated_at, :updated_on, :deleted_on]

  attr_accessible :message, :item, :table, :username

  default_scope order('id DESC')

  def self.latest
    self.limit(100)
  end

  def self.create_update_history(model, object, associations_before, associations_after, modified_associations, old_object, user)
    messages = []
    changed_property_list = []
    properties = model.properties.reject{|p| IGNORED_ATTRS.include?(p[:name])}

    properties.each do |p|
      property_name = p[:name].to_param
      changed_property_list << property_name if old_object.safe_send(property_name) != object.safe_send(property_name)
    end

    model.associations.each do |t|
      assoc = changed_property_list.index(t[:foreign_key].to_param)
      changed_property_list[assoc] = "associated #{t[:pretty_name]}" if assoc
    end

    associations_after.each do |key, current|
      removed_ids = (associations_before[key] - current).map{|m| '#' + m.to_s}
      added_ids = (current - associations_before[key]).map{|m| '#' + m.to_s}
      messages << "Removed #{key.to_s.capitalize} #{removed_ids.join(', ')} associations" if removed_ids.any?
      messages << "Added #{key.to_s.capitalize} #{added_ids.join(', ')} associations" if added_ids.any?
    end

    modified_associations.uniq.each { |t| changed_property_list << "associated #{t}" }

    messages << "Changed #{changed_property_list.join(", ")}" unless changed_property_list.empty?
    create_history_item(messages, object, model, user) unless messages.empty?
  end

  def self.create_history_item(message, object, abstract_model, user)
    create(
       :message => [message].flatten.join(', '),
       :item => object.id,
       :table => abstract_model.pretty_name,
       :username => user.try(:email)
     )
  end

  def self.history_for_model(model, query, sort, sort_reverse, all, page, per_page = (RailsAdmin::Config.default_items_per_page || 20))
    history = where(:table => model.pretty_name)
    history = history.where("message LIKE ? OR username LIKE ?", "%#{query}%", "%#{query}%") if query
    history = history.order(sort_reverse == "true" ? "#{sort} DESC" : sort) if sort
    all ? history : history.send(Kaminari.config.page_method_name, page.presence || "1").per(per_page)
  end

  def self.history_for_object(model, object, query, sort, sort_reverse, all, page, per_page = (RailsAdmin::Config.default_items_per_page || 20))
    history = where(:table => model.pretty_name, :item => object.id)
    history = history.where("message LIKE ? OR username LIKE ?", "%#{query}%", "%#{query}%") if query
    history = history.order(sort_reverse == "true" ? "#{sort} DESC" : sort) if sort
    all ? history : history.send(Kaminari.config.page_method_name, page.presence || "1").per(per_page)
  end
end
