if defined?(Mongoid::Document)
  require 'dragonfly'

  app = Dragonfly[:images]

  # Configure to use ImageMagick, Rails defaults
  app.configure_with(:imagemagick)

  # Allow all mongoid models to use the macro 'image_accessor'
  app.define_macro_on_include(Mongoid::Document, :image_accessor)
end
