## Known incompatibilities, from namespacing issues:

 * [[nested_form|https://github.com/ryanb/nested_form]] (simply [[use the forked RailsAdmin dependency|https://github.com/bbenezech/nested_form]], it is 100% API compatible with Ryan's)
 * various [[Twitter Bootstrap|https://github.com/twitter/bootstrap]] Asset-Pipeline vendoring libraries (use RailsAdmin dependency [[bootstrap-sass|https://github.com/thomas-mcdonald/bootstrap-sass]])
 * [[will_paginate|https://github.com/mislav/will_paginate]] (use RailsAdmin dependency [[kaminari|https://github.com/amatsuda/kaminari]])

## Other issues:

**Locale is being forced to `:en`** whereas config.i18n.default_locale = `:de`

Reason: RailsAdmin DSL needs access to locale before default_locale being set by application.rb

See: https://github.com/sferik/rails_admin/issues/746

Workaround: add `I18n.default_locale = :de` inside RailsAdmin's initializer (before model configs)

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

Another problem on `heroku`, if you get a `ActionView::Template::Error (rails_admin/rails_admin.css isn't precompiled)`, this means that Heroku did not get the precompile array at compilation time from RailsAdmin engine.

Add this to your `config/environments/production.rb`:

```ruby
  config.assets.precompile += ["rails_admin/rails_admin.js", "rails_admin/rails_admin.css", "rails_admin/jquery.colorpicker.js", "rails_admin/jquery.colorpicker.css"]
```

If you still have issue with the asset pipeline:

* make sure you didn't commit your assets in public/assets
* Some css/js assets are not meant to be compiled alone:
 * make sure you don't have any catch-all *.(css|js) in `config.assets.precompile`
 * make sure you don't have any catch-all `require_tree .` in application.(css|js)
* copy all asset related configuration from application.rb and environment/*.rb files from a fresh (`rails new dummy`) rails app
* remove old assets with `bundle exec rake assets:clean` when in development
* read thoroughly the [Rails Guide](http://guides.rubyonrails.org/asset_pipeline.html)

***

**Using model name AdminUser results in infinite redirection**

This happens because Rails engine router is greedy. It matches `/admin_users/sign_in` with `RailsAdmin::Engine`'s `_users/sign_in` which one is not authorized to see.

You can use a different URL scope for `RailsAdmin` by changing `mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'` in your `config/routes.rb`. e.g. You could do `mount RailsAdmin::Enging => '/foo_admin', ...`.

***

**Double insertion of NestedFields**

jquery_nested_form is evaluated twice. Check your assets. Don't commit your assets to public/assets. See [[#924|https://github.com/sferik/rails_admin/issues/924]]