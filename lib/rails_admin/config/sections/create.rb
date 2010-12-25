require "rails_admin/config/sections/update"

module RailsAdmin
  module Config
    module Sections
      # Configuration of the edit view for a new object
      class Create < RailsAdmin::Config::Sections::Update
        # Override inspect for nicer console output
        def inspect
          "#{self.to_s} - Configuration for #{abstract_model.model.name}'s create view"
        end
      end
    end
  end
end