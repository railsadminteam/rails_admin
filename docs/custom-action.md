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

https://github.com/railsadminteam/rails_admin/blob/master/lib/rails_admin/config/actions/base.rb

It is also possible to inherit from any other action class.

## Resources

How to create custom action in Rails admin, as a plugin:

http://blog.endpoint.com/2012/03/railsadmin-custom-action-case-study.html

Add a custom action without needing to add it as a plugin:

https://web.archive.org/web/20180828051240/http://blog.paulrugelhiatt.com/ruby/rails/2014/10/27/rails-admin-custom-action-example.html

Create a custom action:

https://blog.codeminer42.com/writing-custom-railsadmin-actions-e0799aadc8ae

## Double pjax

If you're seeing a double call to your new action, try disabling pjax.

```ruby
register_instance_option :pjax? do
  false
end
```

## Automatically add custom action to rails_admin available action

The order in the menu (if it's a custom action, is the position in the main navigation sidapanel) is given by the requiring it befor or after other custom actions but all custom actions, loaded this way, are placed the end of the default actions.

In an initializer, say `[ENGINE_NAME]\config\initializers\my_action_initializer.rb`

```ruby
RailsAdmin.config do |config|
    config.actions do
        thecore_record_analysis
    end
end
```

## Manage custom action's visibility via CanCanCan

### Root Actions

Example (in case the root action is called my_root_action and rails admin ~> 1):

```ruby
can :my_root_action, :all if user.admin?
```

For rails admin ~> 2

```ruby
can :read, :my_root_action if user.admin?
```
