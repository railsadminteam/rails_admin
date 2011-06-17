require 'test_helper'
require 'rails/performance_test_help'

# These are some generic page rendering tests that should provide a
# birds eye view on applications performance.
#
# To run these tests use test:profile rake task (bundle exec rake test:profile)
# within dummy_app (rails_admin/spec/dummy_app)
#
# Currently performance testing doesn't seem to work on ruby 1.9.2 for
# some reason.
class RenderingTest < ActionDispatch::PerformanceTest

  include Warden::Test::Helpers

  def setup
    user = RailsAdmin::AbstractModel.new("User").create(
      :email => "username@example.com",
      :password => "password"
    )

    login_as user
  end

  def test_render_list_view
    get list_path(:model_name => "player")
  end

  def test_render_create_view
    get new_path(:model_name => "player")
  end
end
