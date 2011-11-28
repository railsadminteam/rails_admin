RailsAdmin::Engine.routes.draw do
  scope "history", :as => "history" do
    controller "history" do
      match "/:model_name", :to => :for_model, :as => "model"
      match "/:model_name/:id", :to => :for_object, :as => "object"
    end
  end

  controller "main" do
    match   "/", :to => :dashboard, :as => "dashboard"
    scope ":model_name" do
      match "/",             :to => :index,        :as => "index", :via => [:get, :post]
      match "/export",       :to => :export,       :as => "export"
      get   "/new",          :to => :new,          :as => "new"
      post  "/new",          :to => :create,       :as => "create"
      post  "/bulk_action",  :to => :bulk_action,  :as => "bulk_action"
      post  "/bulk_destroy", :to => :bulk_destroy, :as => "bulk_destroy"
      scope ":id" do
        get     "/",       :to => :show,    :as => "show"
        get     "/edit",   :to => :edit,    :as => "edit"
        put     "/edit",   :to => :update,  :as => "update"
        get     "/delete", :to => :delete,  :as => "delete"
        delete  "/delete", :to => :destroy, :as => "destroy"
      end
    end
  end
end

