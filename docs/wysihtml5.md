http://jhollingworth.github.com/bootstrap-wysihtml5/

Add `gem 'bootstrap-wysihtml5-rails'` to your Gemfile

Then update config file `config/initializers/rails_admin.rb`

```ruby
RailsAdmin.config do |config|
  config.model Team do
    edit do
      # For RailsAdmin >= 0.5.0
      field :description, :wysihtml5
      # For RailsAdmin < 0.5.0
      # field :description do
      #   bootstrap_wysihtml5 true
      # end
    end
  end
end
```

[[More here|https://github.com/sferik/rails_admin/blob/master/lib/rails_admin/config/fields/types/wysihtml5.rb]]