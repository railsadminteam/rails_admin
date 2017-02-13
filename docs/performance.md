The following are some tips and tricks to improve performance of Rails Admin with larger databases.

## Edit Page Performance

A common source of slow-loading edit pages for me came from fields that are associations to large tables being editable. When loading the edit page, Rails Admin would try to figure out the list of options to present.

For example, if I have a User model which `has_many :comments`, that `comments` field is editable (the default), and I have millions of rows in my `comments` table, then when I attempt to load the user edit page, Rails Admin appears to issue a `select * from comments`.