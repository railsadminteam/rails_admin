Rails.application.routes.draw do |map|

  # Routes for rails_admin controller
  controller "rails_admin" do            
    
    # Prefix route urls with "admin" and route names with "rails_admin_"
    scope "admin", :as => "rails_admin" do            
      
      match "/", :to => :index, :as => "dashboard"
      
      match "/history/list", :to => :history, :as => "history"
      match "/history/get", :to => :get_history, :as => "history_get"
      
      match "/:model_name", :to => :list, :as => "list"
      match "/:model_name/set", :to => :get_pages, :as => "set"
      match "/:model_name/history", :to => :show_history, :as => "show_history"
      
      ["new", "create", "edit", "update", "delete", "destroy"].each do |action|
        match "/:model_name/#{action}", :to => action.to_sym, :as => action
      end
    end
  end  

end
