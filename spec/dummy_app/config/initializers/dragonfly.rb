if defined?(Mongoid::Document)
  require 'dragonfly'

  app = Dragonfly[:images]

  # Configure to use ImageMagick, Rails defaults, and the Mongo data store
  app.configure_with(:imagemagick)
  app.configure_with(:rails) do |c|
    c.datastore = Dragonfly::DataStorage::MongoDataStore.new :db => Mongoid.database
  end

  # Allow all mongoid models to use the macro 'image_accessor'
  app.define_macro_on_include(Mongoid::Document, :image_accessor)
end
