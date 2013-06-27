Add
```ruby
gem 'codemirror-rails'
```
to your Gemfile.

```ruby
RailsAdmin.config do |config|
  config.model Team do
    edit do
      field :description, :code_mirror
    end
  end
end
```

[[More here|https://github.com/sferik/rails_admin/blob/master/lib/rails_admin/config/fields/types/code_mirror.rb]]