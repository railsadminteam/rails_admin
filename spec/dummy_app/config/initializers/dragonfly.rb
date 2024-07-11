

require 'dragonfly'

# Logger
Dragonfly.logger = Rails.logger

# Configure
Dragonfly.app.configure do
  plugin :imagemagick

  protect_from_dos_attacks true
  secret '904547b2be647f0e11a76933b3220d6bd2fb83f380ac760125e4daa3b9504b4e'

  url_format '/media/:job/:name'

  datastore(:file,
            root_path: Rails.root.join('public/system/dragonfly', Rails.env),
            server_root: Rails.root.join('public'))
end

# Mount as middleware
Rails.application.middleware.use Dragonfly::Middleware
