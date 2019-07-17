## Create a reusable action `ActionName`

```bash
rails plugin new rails_admin_<action_name> -m https://gist.github.com/bbenezech/1621146/raw/5268788e715397bf476c83d76d335f152095e659/rails_admin_action_creator --skip-gemfile --skip-bundle -T -O -S -J --full
```

## Add it to your project

```ruby
# Gemfile

# if uploaded to github with a valid .gemspec (remove TODOS and change owner credentials)
gem 'rails_admin_<action_name>', :git => 'git://github.com/<username>/rails_admin_<action_name>.git'
# or in development mode
gem 'rails_admin_<action_name>', :path => '../rails_admin_<action_name>'
```

## Development documentation

See the Base class your `ActionName` will inherit from: 

[[https://github.com/sferik/rails_admin/blob/master/lib/rails_admin/config/actions/base.rb]]

It is also possible to inherit from any other action class.

## Useful link 
 Here is a useful link describing how to create custom action in Rails admin, as a plugin 

 [[http://blog.endpoint.com/2012/03/railsadmin-custom-action-case-study.html]]

 Here's another example, which adds a custom action without needing to add it as a plugin:

 [[https://web.archive.org/web/20180828051240/http://blog.paulrugelhiatt.com/ruby/rails/2014/10/27/rails-admin-custom-action-example.html]]

## Double pjax

If you're seeing a double call to your new action, try disabling pjax.

```ruby
register_instance_option :pjax? do
  false
end
```

 