# Base

Base section.

All other sections inherits from it.
It's the section used in configuration when no section is specified (you can also explicitly use the `base` section name).

Example:

```ruby
RailsAdmin.config do |config|
  config.model Team do
    configure :name do
      label "Team's name"
    end
  end
end
```

[More here](../lib/rails_admin/config/sections/base.rb)
