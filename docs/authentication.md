# Authentication

You can (each is optional) provide 2 things:

1. An `authenticate_with` block that will trigger your authentication logic before any action in RailsAdmin.
2. A `current_user_method` block that will yield a user model (for UI purposes)

If your application responds to a route helper named `logout_path` then Rails Admin will add a "Log out" button to the top-right corner of your app. _[Needs expansion: There's also a Devise integration but I don't know how Devise works. See [#1386](https://github.com/railsadminteam/rails_admin/issues/1386) for details.]_

Popular authentication gems examples:

- [Devise](devise.md)
- [Sorcery](sorcery.md)
- [Manually](manually.md)
