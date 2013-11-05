* First install [[PaperTrail|https://github.com/airblade/paper_trail]] _Note: you should use the `--with-changes` option when creating the version table to ensure that history messages are recorded._ 
* add the `has_paper_trail` statements to the tracked models
* add this to your `rails_admin.rb` initializer:

```ruby
config.audit_with :paper_trail, User
```

User should be your 'user' model.