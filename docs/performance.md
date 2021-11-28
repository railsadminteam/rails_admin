# Performance

The following are some tips and tricks to improve performance of Rails Admin with larger databases.

## Edit Page Performance

A common source of slow-loading edit pages for me is fields that are associations to large tables being editable.

For example, if I have a User model which `has_many :comments`, the `comments` field is editable (the default), and I have millions of rows in my `comments` table, then when I attempt to load the user edit page, Rails Admin appears to issue a `select * from comments`.

Marking associations to large tables as `readonly` has often been the culprit behind poor edit page performance for me.

### Making all fields readonly by default

If you're expecting large tables, it could be beneficial to make all fields of all models readonly by default from the start, and then manually set fields to `readonly true` within individual models as needed.

See [Making all fields readonly by default](fields.md#making-all-fields-readonly-by-default) for how to do this.

## History Tab performance

I've also managed to speed up loads on index pages and the history tab with the following. (Note: Only do this if you don't use Kaminari in your actual app.)

```rb
module Kaminari
  module ActiveRecordRelationMethods
    def total_count(column_name = :all, _options = nil)
      limit(5000).count(column_name)
    end
  end
end
```

This can also help performance if you are using the [`rails_admin_history_rollback`](https://github.com/rikkipitt/rails_admin_history_rollback) gem, as the "View Changes" button also issues a full count on the versions table.

See [#2808](https://github.com/railsadminteam/rails_admin/issues/2808) for further discussion.
