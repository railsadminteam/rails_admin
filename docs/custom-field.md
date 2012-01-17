## Create a reusable field <FieldName>

```
rails plugin new rails_admin_<field_name> -m https://raw.github.com/gist/1626605/ --skip-gemfile --skip-bundle -T -O -S -J --full
```

## Add it to your project

```ruby
# Gemfile

# if uploaded to github with a valid .gemspec
gem 'rails_admin_<field_name>', :git => 'https://github.com/<username>/rails_admin_<field_name>'
# or in development mode
gem 'rails_admin_<field_name>', :path => '../rails_admin_<field_name>'

# config/rails_admin.rb

config.actions do
  dashboard
  ...
  <field_name>
end
```

## Development documentation

See the Base class your <FieldName> will inherit from: 

[[https://github.com/sferik/rails_admin/blob/master/lib/rails_admin/config/fields/base.rb]]