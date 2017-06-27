In config/initializers/rails_admin.rb, you can add the following lines of code:

    config.authenticate_with do
      authenticate_or_request_with_http_basic('Login required') do |username, password|
        user = User.where(email: username, password: password, admin: true).first
        user
      end
    end

This will call your User object from the database and check if it exists,
If yes, it will login else it won't.