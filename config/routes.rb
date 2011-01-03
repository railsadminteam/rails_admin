Rails.application.routes.draw do

  # Prefix route urls with "admin" and route names with "rails_admin_"
  scope "admin", :module => :rails_admin, :as => "rails_admin" do
    # Routes for rails_admin controller
    controller "main" do
      match "/", :to => :index, :as => "dashboard"
      get "/:model_name", :to => :list, :as => "list"
      get "/:model_name/new", :to => :new, :as => "new"
      match "/:model_name/get_pages", :to => :get_pages, :as => "get_pages"
      match "/:model_name/history", :to => :show_history, :as => "show_history"
      post "/:model_name", :to => :create, :as => "create"
      get "/:model_name/:id/edit", :to => :edit, :as => "edit"
      put "/:model_name/:id", :to => :update, :as => "update"
      get "/:model_name/:id/delete", :to => :delete, :as => "delete"
      delete "/:model_name/:id", :to => :destroy, :as => "destroy"
    end
    scope "history", :as => "history" do
      controller "history" do
        match "/list", :to => :list, :as => "list"
      end
    end
  end

end
