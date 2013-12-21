Section used for the export view.

It inherits its configuration from the `base` section.

**Specify fields to export**

```ruby
RailsAdmin.config do |config|
  config.model 'Highway' do
    export do
      field :number_of_lanes
    end
  end
end
```

[[More here|https://github.com/sferik/rails_admin/blob/master/lib/rails_admin/config/sections/export.rb]]