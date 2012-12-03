class RailsAdmin::History < ActiveRecord::Base
  self.table_name = :rails_admin_histories

  IGNORED_ATTRS = Set[:id, :created_at, :created_on, :deleted_at, :updated_at, :updated_on, :deleted_on]

  attr_accessible :message, :item, :table, :username

  default_scope order('id DESC')

  def self.latest
    self.limit(100)
  end

  def self.create_history_item(message, object, abstract_model, user)
    create(
       :message => [message].flatten.join(', '),
       :item => object.id,
       :table => abstract_model.to_s,
       :username => user.try(:email)
     )
  end

  def self.history_for_model(abstract_model, query, sort, sort_reverse, all, page, per_page = (RailsAdmin::Config.default_items_per_page || 20))
    history = where(:table => abstract_model.to_s)
    history = history.where("message LIKE ? OR username LIKE ?", "%#{query}%", "%#{query}%") if query
    history = history.order(sort_reverse == "true" ? "#{sort} DESC" : sort) if sort
    all ? history : history.send(Kaminari.config.page_method_name, page.presence || "1").per(per_page)
  end

  def self.history_for_object(abstract_model, object, query, sort, sort_reverse, all, page, per_page = (RailsAdmin::Config.default_items_per_page || 20))
    history = where(:table => abstract_model.to_s, :item => object.id)
    history = history.where("message LIKE ? OR username LIKE ?", "%#{query}%", "%#{query}%") if query
    history = history.order(sort_reverse == "true" ? "#{sort} DESC" : sort) if sort
    all ? history : history.send(Kaminari.config.page_method_name, page.presence || "1").per(per_page)
  end
end
