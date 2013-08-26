DummyApp::Application.routes.draw do
  # Needed for :show_in_app tests
  resources :players, :only => [:show]

  devise_for :users
  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'
  root :to => "rails_admin/main#dashboard"
  # https://github.com/sferik/rails_admin/issues/362
  get ':controller(/:action(/:id(.:format)))'
end
