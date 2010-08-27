RailsAdmin::Application.routes.draw do
  devise_for :users
  match "/admin", :to => "rails_admin#index", :as => :rails_admin_dashboard
  match "/admin/:model_name", :to => "rails_admin#list", :as => :rails_admin_list
  match "/admin/:model_name/new", :to => "rails_admin#new", :as => :rails_admin_new
  match "/admin/:model_name/create", :to => "rails_admin#create", :as => :rails_admin_create
  match "/admin/:model_name/edit", :to => "rails_admin#edit", :as => :rails_admin_edit
  match "/admin/:model_name/update", :to => "rails_admin#update", :as => :rails_admin_update
  match "/admin/:model_name/delete", :to => "rails_admin#delete", :as => :rails_admin_delete
  match "/admin/:model_name/destroy", :to => "rails_admin#destroy", :as => :rails_admin_destroy
end
