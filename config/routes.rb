Rails.application.routes.draw do |map|
  match "/admin", :to => "rails_admin#index", :as => :rails_admin_dashboard
  match "/admin/history/list", :to => "rails_admin#history", :as => :rails_admin_history
  match "/admin/history/get", :to => "rails_admin#get_history", :as => :rails_admin_history_get
  match "/admin/:model_name", :to => "rails_admin#list", :as => :rails_admin_list
  match "/admin/:model_name/set", :to => "rails_admin#get_pages", :as => :rails_admin_set
  match "/admin/:model_name/new", :to => "rails_admin#new", :as => :rails_admin_new
  match "/admin/:model_name/create", :to => "rails_admin#create", :as => :rails_admin_create
  match "/admin/:model_name/edit", :to => "rails_admin#edit", :as => :rails_admin_edit
  match "/admin/:model_name/update", :to => "rails_admin#update", :as => :rails_admin_update
  match "/admin/:model_name/delete", :to => "rails_admin#delete", :as => :rails_admin_delete
  match "/admin/:model_name/destroy", :to => "rails_admin#destroy", :as => :rails_admin_destroy
end
