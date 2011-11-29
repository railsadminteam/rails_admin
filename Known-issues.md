### Locale is being forced to `:en` whereas config.i18n.default_locale = `:de`

Reason: RailsAdmin DSL needs access to locale before default_locale being set by application.rb

See: https://github.com/sferik/rails_admin/issues/746

Workaround: add `I18n.default_locale = :de` inside RailsAdmin's initializer (before model configs)


### `to_xs` failure when exporting records to xml with ruby != 1.9.x

Check Rails bug status here: https://github.com/rails/rails/pull/2076


### Asset pipeline

The master branch currently targets Rails 3.1. Older branch with 3.0 compatibility is present, but is no longer maintained.

If you are updating from a Rails 3.0 application, you will no longer need to
update your assets, they will be served from the engine (through Sprockets).
You can delete all RailsAdmin related assets in your public directory.
RailsAdmin needs the asset pipeline. Activate it in `application.rb`:

    config.assets.enabled = true

Please note that `initializer/rails_admin.rb` is very likely to require access to your DB.
Thus if don't need access to your application at asset compilation time,

    config.assets.initialize_on_precompile = false

will reduce your compilation time and is recommended.
Note that this is needed on **Heroku** if you set `compile = false` and don't versionate `public/assets`.
More here: http://devcenter.heroku.com/articles/rails31_heroku_cedar

If you still have issue with the asset pipeline:

* ake sure you are using latest Rails 3.1 and Sprockets release
* copy all asset related configuration from application.rb and environment/*.rb files from a fresh (`rails new dummy`) rails app
* remove old assets with `bundle exec rake assets:clean` when in development
* read thoroughly the [Rails Guide](http://guides.rubyonrails.org/asset_pipeline.html)
