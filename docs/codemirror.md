# CodeMirror

Add

```ruby
gem 'codemirror-rails'
```

to your Gemfile.

```ruby
RailsAdmin.config do |config|
  config.model Team do
    edit do
      # For RailsAdmin >= 0.5.0
      field :description, :code_mirror
      # For RailsAdmin < 0.5.0
      # field :description do
      #   codemirror true
      # end
    end
  end
end
```

This code that you see upper hide all other columns and left only description.
Ruby 2.1.0 Rails 4.0.2 - this configuration helped me.

```ruby
RailsAdmin.config do |config|
  config.model Team do
    configure :code, :code_mirror
  end
end
```

[More here](../lib/rails_admin/config/fields/types/code_mirror.rb)
