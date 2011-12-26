Base section.

All sections inherits from this one.
It's the section used 

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
