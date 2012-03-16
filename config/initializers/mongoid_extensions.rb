if defined?(::Mongoid::Document)
  require 'rails_admin/adapters/mongoid/extension'
  Mongoid::Document.send(:include, RailsAdmin::Adapters::Mongoid::Extension)
  Mongoid::NestedAttributes::ClassMethods.send(:include, RailsAdmin::Adapters::Mongoid::NestedAttributesExtension)
end
