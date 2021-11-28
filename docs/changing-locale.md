# Changing locale

Creating a separate controller (inherit from ActionController::Base not ApplicationController) with I18n logic and inherit rails_admin controller from it in a config file will do the job.

```ruby
class RailsAdminAbstractController < ActionController::Base
  around_action :switch_locale

  private

  def switch_locale(&action)
    I18n.with_locale(:en, &action) # or anything you like
  end
end
```

`config/initializers/rails_admin.rb`

```ruby
...
RailsAdmin.config do |config|
  ...
  config.parent_controller = '::RailsAdminAbstractController'
  ...
```

See also [this](https://github.com/railsadminteam/rails_admin/pull/2805) and never forget about [this](https://guides.rubyonrails.org/i18n.html#managing-the-locale-across-requests).
