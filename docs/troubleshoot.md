## Known incompatibilities, from namespacing issues:

- various [Twitter Bootstrap](https://github.com/twitter/bootstrap) Asset-Pipeline vendoring libraries (use RailsAdmin dependency [bootstrap-sass](https://github.com/thomas-mcdonald/bootstrap-sass))
- [devise_invitable](https://github.com/scambra/devise_invitable) can result in an issue. See [this](http://stackoverflow.com/questions/6012792/devise-invitable-rails-admin-conflict) Stack Overflow question for more info.
- [~~will_paginate~~](https://github.com/mislav/will_paginate) (Now we have a way to avoid method name collision. See ['Conflict between will_paginate and kaminari'](#conflict-between-will_paginate-and-kaminari) section below)

## Known fix for twitter-bootstrap-rails:

Just copy the `<path to gems>rails_admin/app/assets/javascripts/rails_admin/rails_admin.js` file to `<yourapp>/app/assets/javascripts/rails_admin/rails_admin.js`.
Then replace "require_asset 'bootstrap'" with "require_asset 'twitter/bootstrap'".
Now twitter-bootstrap-rails works with rails_admin.

## Known fix for anjlab-bootstrap-rails:

I am using gem [anjlab-bootstrap-rails](https://github.com/anjlab/bootstrap-rails), the fix steps for javascript as the above one, but we also need to fix the stylesheets import. Not sure if it's missing or not required for the above fix, we do need the additonal step if you are using this gem.

First, Just copy the rails_admin/app/assets/javascripts/rails_admin/rails_admin.js.erb file to <yourapp>/app/assets/javascripts/rails_admin/rails_admin.js.erb.
Then replace "require_asset 'bootstrap'" with "require_asset 'twitter/bootstrap'".

Second, Just copy the rails_admin/app/assets/stylesheets/rails_admin/imports.css.scss.erb file to <yourapp>/app/assets/stylesheets/rails_admin/imports.css.scss.erb.
Then replace "@import "bootstrap" with "@import "twitter/bootstrap".
Now twitter-bootstrap-rails works with rails_admin.

## Other issues:

### Locale is being forced to `:en` whereas config.i18n.default_locale = `:de`

Reason: RailsAdmin DSL needs access to locale before default_locale being set by application.rb

See: https://github.com/railsadminteam/rails_admin/issues/746

Workaround: add `I18n.default_locale = :de` inside RailsAdmin's initializer (before model configs)

---

### Asset pipeline

The master branch currently targets Rails >= 6.0. `rails_admin@2.x.x` (see the [`2.x-stable` branch](https://github.com/railsadminteam/rails_admin/blob/2.x-stable/rails_admin.gemspec#L15)) targets Rails >= 5.0. Older Rails versions may work, but are not actively maintained.

If you are updating from a Rails 3.0 application, you will no longer need to
update your assets, they will be served from the engine (through Sprockets).
You can delete all RailsAdmin related assets in your public directory.
RailsAdmin needs the asset pipeline. Activate it in `application.rb`:

```ruby
config.assets.enabled = true
```

Please note that `initializer/rails_admin.rb` is very likely to require access to your DB.
Thus, if you don't need access to your application at asset compilation time,

```ruby
config.assets.initialize_on_precompile = false
```

will reduce your compilation time and is recommended.
Note that this is needed on **Heroku** if you set `compile = false` and don't version `public/assets`.
More here: http://devcenter.heroku.com/articles/rails31_heroku_cedar

Also, as of version 0.0.4, you have to add this to successfully precompile assets. This is also needed if you're deploying in **Heroku**.
(See [#1192](https://github.com/railsadminteam/rails_admin/issues/1192) for the issue report and [#1046](https://github.com/railsadminteam/rails_admin/issues/1046) for the fix.)

```ruby
config.assets.precompile += ['rails_admin/rails_admin.css', 'rails_admin/rails_admin.js']
```

If you still have issue with the asset pipeline:

- make sure you didn't commit your assets in public/assets
- Some css/js assets are not meant to be compiled alone:
- make sure you don't have any catch-all \*.(css|js) in `config.assets.precompile`
- make sure you don't have any catch-all `require_tree .` in application.(css|js)
- copy all asset related configuration from application.rb and environment/\*.rb files from a fresh (`rails new dummy`) rails app
- remove old assets with `bundle exec rake assets:clean` when in development
- read thoroughly the [Rails Guide](http://guides.rubyonrails.org/asset_pipeline.html)

---

### Using model name AdminUser results in infinite redirection

This happens because Rails engine router is greedy. It matches `/admin_users/sign_in` with `RailsAdmin::Engine`'s `_users/sign_in` which one is not authorized to see.

You can use a different URL scope for `RailsAdmin` by changing `mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'` in your `config/routes.rb`. e.g. You could do `mount RailsAdmin::Engine => '/foo_admin', ...`.

---

### Double insertion of NestedFields

jquery_nested_form is evaluated twice. Check your assets. Don't commit your assets to public/assets. See [#924](https://github.com/railsadminteam/rails_admin/issues/924)

---

### Conflict between will_paginate and kaminari

will_paginate is known to cause problem when used with kaminari, to which rails_admin has dependency.
To work around this issue, create `config/initializers/kaminari.rb` with following content:

```ruby
Kaminari.configure do |config|
  config.page_method_name = :per_page_kaminari
end
```

to make kaminari to use different paginating method from will_paginate's.

---

### Redirect loop when visiting /admin

In `config/routes.rb` switch lines for devise and RA so they are in this order:

```
devise_for :admins
mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'
```

---

### No route matches [POST] for delete and update

The problem was in missing middleware. I have added

```
config.middleware.use Rack::MethodOverride
```

to `/config/application.rb`
