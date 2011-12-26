You can exclude models from RailsAdmin by appending those models to `excluded_models`:

```ruby
RailsAdmin.config do |config|
  config.excluded_models << "ClassName"
end
```
