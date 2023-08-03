# bootstrap-wysihtml5

http://jhollingworth.github.com/bootstrap-wysihtml5/

- your rails_admin <= 0.6.5
- Add `gem 'bootstrap-wysihtml5-rails', '0.3.1.24'` to your Gemfile that is the last version that supports Bootstrap 2.
- your rails_admin >= 0.6.6
- Add `gem 'bootstrap-wysihtml5-rails', '> 0.3.1.24'` to your Gemfile that supports Bootstrap 3.

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

# To configure the editor bar or the parser rules pass a hash of options:
# For RailsAdmin >= 0.5.0
field :description, :wysihtml5 do
  config_options toolbar: { fa: true }, # use font-awesome instead of glyphicon
                 html: true, # enables html editor
                 parserRules: { tags: { p:1 } } # support for <p> in html mode
end
```

[More here](../lib/rails_admin/config/fields/types/wysihtml5.rb)
