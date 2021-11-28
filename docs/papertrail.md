# PaperTrail

- First install [PaperTrail](https://github.com/paper-trail-gem/paper_trail) and [PaperTrail-AssociationTracking](https://github.com/westonganger/paper_trail-association_tracking)

_Note: you should use the `--with-changes` option when creating the version table
to ensure that history messages are recorded in a `object_changes` column._

```bash
$ bundle exec rails generate paper_trail:install --with-changes
$ bundle exec rails generate paper_trail_association_tracking:install --with-associations
```

- add the `has_paper_trail` statements to the tracked models
- add this to your `rails_admin.rb` initializer:

```ruby
config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0
config.audit_with :paper_trail, 'User', 'Version' # PaperTrail < 3.0.0
```

User should be your 'whodunnit' model.

To show the history:

```ruby
PAPER_TRAIL_AUDIT_MODEL = ['Order', 'Payment']
config.actions do
  history_index do
    only PAPER_TRAIL_AUDIT_MODEL
  end
  history_show do
    only PAPER_TRAIL_AUDIT_MODEL
  end
end
```

To hide the Papertrail links from the side navigation add this to your `rails_admin.rb` initializer:

```ruby
  config.model "PaperTrail::Version" do
    visible false
  end

  config.model "PaperTrail::VersionAssociation" do
    visible false
  end
```
