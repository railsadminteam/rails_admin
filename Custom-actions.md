## Create a reusable action <ActionName>

```
rails plugin new rails_admin_<action_name> -m https://raw.github.com/gist/1621146/ --skip-gemfile --skip-bundle -T -O -S -J --full
```

## Add it to your project

```ruby
# Gemfile

# if uploaded to github with a valid .gemspec
gem 'rails_admin_<action_name>', :git => 'https://github.com/....'
# or in development mode
gem 'rails_admin_<action_name>', :path => '../rails_admin_<action_name>'

# config/rails_admin.rb

config.actions do
  dashboard
  ...
  <action_name>
end
```

## Development documentation

See the Base class your <ActionName> will inherit from: 

[[https://github.com/sferik/rails_admin/blob/master/lib/rails_admin/config/actions/base.rb]]