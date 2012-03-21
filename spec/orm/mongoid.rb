# Configure Dragonfly
require 'dragonfly'
app = Dragonfly[:images]
app.configure_with(:imagemagick)
app.configure_with(:rails) do |c|
  c.datastore = Dragonfly::DataStorage::MongoDataStore.new :db => Mongoid.database
end
app.define_macro_on_include(Mongoid::Document, :image_accessor)


class Tableless
  include Mongoid::Document

  class <<self
    def column(name, sql_type = nil, default = nil, null = true)
      field name, :type => {
        :integer => Integer,
        :string => String,
        :text => String,
        :date => Date,
      }[sql_type]
    end
  end
end
