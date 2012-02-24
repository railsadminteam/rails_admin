DummyApp::Application.routes.draw do
  # Needed for :show_in_app tests
  resources :players, :only => [:show]

  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'
  devise_for :users
  root :to => "rails_admin::Main#dashboard"
  # https://github.com/sferik/rails_admin/issues/362
  match ':controller(/:action(/:id(.:format)))'
end
