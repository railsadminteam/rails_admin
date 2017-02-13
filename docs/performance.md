The following are some tips and tricks to improve performance of Rails Admin with larger databases.

## Edit Page Performance

A common source of slow-loading edit pages for me is fields that are associations to large tables being editable.

For example, if I have a User model which `has_many :comments`, the `comments` field is editable (the default), and I have millions of rows in my `comments` table, then when I attempt to load the user edit page, Rails Admin appears to issue a `select * from comments`.

Marking associations to large tables as `readonly` has often been the culprit behind poor edit page performance for me.