## Create a reusable field `FieldName`

```
rails plugin new rails_admin_<field_name> -m https://gist.github.com/bbenezech/1626605/raw/8f67e4eb05418a92a20649fc551fcd1bacb481d1/rails_admin_field_creator --skip-gemfile --skip-bundle -T -O -S -J --full
```

## Add it to your project

```ruby
# Gemfile

# if uploaded to github with a valid .gemspec (remove TODOS and change owner credentials)
gem 'rails_admin_<field_name>', :git => 'git://github.com/<username>/rails_admin_<field_name>.git'
# or in development mode
gem 'rails_admin_<field_name>', :path => '../rails_admin_<field_name>'
```

## Development documentation

See the Base class your `FieldName` will inherit from:

https://github.com/railsadminteam/rails_admin/blob/master/lib/rails_admin/config/fields/base.rb
