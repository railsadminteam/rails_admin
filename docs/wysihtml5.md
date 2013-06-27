http://jhollingworth.github.com/bootstrap-wysihtml5/

Add `gem 'bootstrap-wysihtml5-rails'` to your Gemfile

```ruby
RailsAdmin.config do |config|
  config.model Team do
    edit do
      field :description, :wysihtml5
    end
  end
end
```

[[More here|https://github.com/sferik/rails_admin/blob/master/lib/rails_admin/config/fields/types/wysihtml5.rb]]