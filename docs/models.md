## Configuration location

A model configuration can be done in any of the places below:

- inside the RailsAdmin initializer:

  ```ruby
  # config/initializers/rails_admin.rb

  RailsAdmin.config do |config|
    config.model 'ModelName' do
      # ...
    end
  end
  ```

- in the model definition file:

  ```ruby
  # app/models/model_name.rb

  class ModelName < ActiveRecord::Base
    rails_admin do
      # ...
    end
  end
  ```

- in a separate concern file:

  ```ruby
  module ModelNameAdmin
    extend ActiveSupport::Concern

    included do
      rails_admin do
        # ...
      end
    end
  end
  ```

  Don't forget to include the concern module in the model file itself by doing:

  ```ruby
  include ModelNameAdmin
  ```

This is your choice to make:

- The initializer is loaded once at startup (modifications will show up when restarting the application) and may slow down your application startup, but all RailsAdmin configuration will stay in one place.
- Models are reloaded at each request in development mode (when modified), which may smooth your RailsAdmin development workflow.

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

_Edit: The above has been reported not to work properly (see https://github.com/railsadminteam/rails_admin/issues/2030). If you're encountering such a problem try this workaround:_

```ruby
# config/initializers/rails_admin.rb
RailsAdmin.config do |config|
  config.model 'Team' do
    object_label_method do
      :custom_label_method
    end
  end
  Team.class_eval do
    def custom_label_method
      "Team #{self.name}"
    end
  end
end
```

_Edit_: Solution 2: Add `object_label_method` to `ApplicationRecord` then send `.decorate` method to use Drapper Decorator.

Add `object_label_method` method.

```ruby
  def object_label_method
    klass = "#{self.class.name}Decorator".classify

    if Object.const_defined? klass
      object = klass.constantize.send(:decorate, self)
      if object.respond_to? :object_label
        object.object_label
      else
        id
      end
    end
  end
```

Then add

```ruby
class UserDecorator < Draper::Decorator
  def object_label
     #...
  end
end
```

or use `alias_method`

```ruby
class UserDecorator < Draper::Decorator
  def display_name
    ["(#{id})", first_name, last_name].join(' ')
  end
  alias_method :object_label, :display_name
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

**Note**: In versions prior to `v1.0.0.rc`, successive invocations of `config.model` to the same model would _replace_ the configuration block rather than adding to it--meaning that the above block gets ignored for any model that also has a config block in the model class. (This was fixed by [#2670](https://github.com/railsadminteam/rails_admin/pull/2670).)
