**Locale is being forced to `:en`** whereas config.i18n.default_locale = `:de`

Reason: RailsAdmin DSL needs access to locale before default_locale being set by application.rb

See: https://github.com/sferik/rails_admin/issues/746

Workaround: add `I18n.default_locale = :de` inside RailsAdmin's initializer (before model configs)

***

**`to_xs` failure when exporting records to xml** with ruby != 1.9.x

Check Rails bug status here: https://github.com/rails/rails/pull/2076

***

**Asset pipeline**

The master branch currently targets Rails 3.1. Older branch with 3.0 compatibility is present, but is no longer maintained.

If you are updating from a Rails 3.0 application, you will no longer need to
update your assets, they will be served from the engine (through Sprockets).
You can delete all RailsAdmin related assets in your public directory.
RailsAdmin needs the asset pipeline. Activate it in `application.rb`:

```ruby
config.assets.enabled = true
```

Please note that `initializer/rails_admin.rb` is very likely to require access to your DB.
Thus if don't need access to your application at asset compilation time,

```ruby
config.assets.initialize_on_precompile = false
```

will reduce your compilation time and is recommended.
Note that this is needed on **Heroku** if you set `compile = false` and don't versionate `public/assets`.
More here: http://devcenter.heroku.com/articles/rails31_heroku_cedar

If you still have issue with the asset pipeline:

* make sure you are using latest Rails 3.1 and Sprockets release
* Some css/js assets are not meant to be compiled alone:
 * make sure you don't have any catch-all *.(css|js) in `config.assets.precompile`
 * make sure you don't have any catch-all `require_tree .` in application.(css|js)
* copy all asset related configuration from application.rb and environment/*.rb files from a fresh (`rails new dummy`) rails app
* remove old assets with `bundle exec rake assets:clean` when in development
* read thoroughly the [Rails Guide](http://guides.rubyonrails.org/asset_pipeline.html)

***

**Kaminari vs Will_paginate** errors

They are not really compatible at the moment. If you find a fix, please provide.
See: https://github.com/gregbell/active_admin/issues/330

***

**Using model name AdminUser results in infinite redirection**

This happens because Rails engine router is greedy. It matches `/admin_users/sign_in` with `RailsAdmin::Engine`'s `_users/sign_in` which one is not authorized to see.

You can use a different URL scope for `RailsAdmin` by changing `mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'` in your `config/routes.rb`. e.g. You could do `mount RailsAdmin::Enging => '/foo_admin', ...`.