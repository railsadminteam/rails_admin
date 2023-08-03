# Routing problems

Your routes.rb should look like this one:

```ruby
DummyApp::Application.routes.draw do
  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'
  devise_for :users
  root :to => "home#index"

  resources :articles
  resources :pages
  match ':controller(/:action(/:id(.:format)))'
end
```

Note 3 things:

- `mount RailsAdmin::Engine => '/admin'` will catch all `/admin` urls, including `/administrator`, which would then blow up in RailsAdmin!
- if you choose to put a catch-up root route before `mount RailsAdmin::Engine`, make sure it doesn't catch '/admin/'
- a root url is necessary for Devise, and will be used in RailsAdmin (home button)
