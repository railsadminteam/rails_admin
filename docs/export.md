# Export

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

**Specify field Value to export with 'export_value'**

```ruby
  RailsAdmin.config do |config|
    config.model 'Lesson' do
      export do
        field :teacher, :string do
          export_value do
            value.name if value #value is an instance of Teacher
          end
        end
      end
    end
  end
```

[More here](../lib/rails_admin/config/sections/export.rb)
