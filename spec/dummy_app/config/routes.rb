DummyApp::Application.routes.draw do
  devise_for :users
  root :to => "rails_admin::Main#index"

  # https://github.com/sferik/rails_admin/issues/362
  match ':controller(/:action(/:id(.:format)))'

end
