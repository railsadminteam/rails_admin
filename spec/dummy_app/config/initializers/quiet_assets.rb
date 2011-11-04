# https://github.com/rails/rails/issues/3164
# http://stackoverflow.com/questions/6312448/how-to-disable-logging-of-asset-pipeline-sprockets-messages-in-rails-3-1

Rails.application.assets.logger = Logger.new('/dev/null')
Rails::Rack::Logger.class_eval do
  def before_dispatch_with_quiet_assets(env)
    before_dispatch_without_quiet_assets(env) unless env['PATH_INFO'].index("/assets/") == 0
  end
  alias_method_chain :before_dispatch, :quiet_assets
end
