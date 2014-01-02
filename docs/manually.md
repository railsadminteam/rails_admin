You can skip installation of Devise and choose whatever authorization option for your needs.

Just install with

```bash
$ rails generate rails_admin:install --skip-devise
```

and you're ready to use RailsAdmin without any access control.

You can even build your custom authorization logic, such as:

```ruby
RailsAdmin.config do |config|
  config.authorize_with do
    authenticate_or_request_with_http_basic('Site Message') do |username, password|
      username == 'foo' && password == 'bar'
    end
  end
end
```