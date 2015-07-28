## Configuration location

Each model configuration can alternatively be in two places:

* Inside the RailsAdmin initializer

`config/initializers/rails_admin.rb`
```ruby
RailsAdmin.config do |config|
  ...
  config.model 'ModelName' do 
    ...
  end
end
```

* In the model definition file:

_app/models/model_name.rb_
```ruby
class ModelName < ActiveRecord::Base
  ...
  rails_admin do 
    ...
  end
end
```

This is your choice to make:
* The initializer is loaded once at startup (modifications will show up when restarting the application) and may slow down your application startup, but all RailsAdmin configuration will stay in one place.
* Models are reloaded at each request in development mode (when modified), which may smooth your RailsAdmin development workflow.

## The `object_label_method` method

The model configuration option `object_label_method` configures
the title display of a single database record, i.e. an instance of a model.

By default it tries to call "name" or "title" methods on the record in question. If the object responds to neither,
then the label will be constructed from the model's classname appended with its
database identifier. You can add label methods (or replace the default [:name, :title]) with:

```ruby
RailsAdmin.config {|c| c.label_methods << :description}
```

This `object_label_method` value is used in a number of places in RailsAdmin--for instance for the
output of belongs to associations in the listing views of related models, for
the option labels of the relational fields' input widgets in the edit views of
related models and for part of the audit information stored in the history
records--so keep in mind that this configuration option has widespread
effects.

```ruby
RailsAdmin.config do |config|
  config.model 'Team' do
    object_label_method do
      :custom_label_method
    end
  end

  def custom_label_method
    "Team #{self.name}"
  end
end
```

### Difference between `label` and `object_label`

`label` and `object_label` are both model configuration options. `label` is used
whenever Rails Admin refers to a model class, while `object_label` is used whenever
Rails Admin refers to an instance of a model class (representing a single database record).

## Configuring models all at once

If you want to use `config.model` for all models, you may find it in `ActiveRecord::Base.descendants`

If `cache_classes` is off (by default it's off in development, but on in production):
Call `Rails.application.eager_load!` before the following:

```ruby
RailsAdmin.config do |config|
  ActiveRecord::Base.descendants.each do |imodel|
    config.model "#{imodel.name}" do
      list do
        exclude_fields :created_at, :updated_at
      end
    end
  end
end
```