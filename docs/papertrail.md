* First install [[PaperTrail|https://github.com/airblade/paper_trail]]  

_Note: you should use the `--with-changes` option when creating the version table  
to ensure that history messages are recorded in a `object_changes` column._

```bash
$ bundle exec rails generate paper_trail:install --with-changes  
   Connecting to database specified by database.yml`
      create  db/migrate/20131113103143_create_versions.rb
      create  db/migrate/20131113103144_add_object_changes_column_to_versions.rb
```

* add the `has_paper_trail` statements to the tracked models
* add this to your `rails_admin.rb` initializer:

```ruby
config.audit_with :paper_trail, 'User', 'Papertrail::Version' # PaperTrail >= 3.0.0
config.audit_with :paper_trail, 'User', 'Version' # PaperTrail < 3.0.0
```

User should be your 'user' model.