* First install [[PaperTrail|https://github.com/airblade/paper_trail]]
* add the `has_paper_trail` statements to the tracked models
* add this to your `rails_admin.rb` initializer:

```ruby
config.audit_with :paper_trail, User
```

User should be your 'user' model.