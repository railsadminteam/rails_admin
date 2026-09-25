## Known incompatibilities:

- [devise_invitable](https://github.com/scambra/devise_invitable) can result in an issue. See [this](http://stackoverflow.com/questions/6012792/devise-invitable-rails-admin-conflict) Stack Overflow question for more info.
- [~~will_paginate~~](https://github.com/mislav/will_paginate) (Now we have a way to avoid method name collision. See ['Conflict between will_paginate and kaminari'](#conflict-between-will_paginate-and-kaminari) section below)

## Other issues:

### Locale is being forced to `:en` whereas config.i18n.default_locale = `:de`

Reason: RailsAdmin DSL needs access to locale before default_locale being set by application.rb

See: [#746](https://github.com/sferik/rails_admin/issues/746), [#3140](https://github.com/railsadminteam/rails_admin/issues/3140)

Workaround: Using a custom `parent` controller, add an `around_action` that sets the locale for the request.

```ruby
# initializers/rails_admin.rb
RailsAdmin.config do |config|
  config.parent_controller = "Admin::BaseController"
end

# controllers/admin/base_controller.rb
class Admin::BaseController < ActionController::Base
  around_action :use_default_locale

  private

  def use_default_locale(&block)
    # Executes the request with the I18n.default_locale.
    # https://github.com/ruby-i18n/i18n/commit/9b14943d5e814723296cd501283d9343985fca4e
    I18n.with_locale(I18n.default_locale, &block)
  end
end
```

[Related Rails Guides](https://guides.rubyonrails.org/i18n.html#managing-the-locale-across-requests)

---

### Using model name AdminUser results in infinite redirection

This happens because Rails engine router is greedy. It matches `/admin_users/sign_in` with `RailsAdmin::Engine`'s `_users/sign_in` which one is not authorized to see.

You can use a different URL scope for `RailsAdmin` by changing `mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'` in your `config/routes.rb`. e.g. You could do `mount RailsAdmin::Engine => '/foo_admin', ...`.

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
