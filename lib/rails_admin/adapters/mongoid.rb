# frozen_string_literal: true

require 'mongoid'
require 'rails_admin/config/sections/list'

module RailsAdmin
  module Adapters
    module Mongoid
      DISABLED_COLUMN_TYPES = %w[Range Moped::BSON::Binary BSON::Binary Mongoid::Geospatial::Point].freeze
    end
  end
end

require 'rails_admin/adapters/mongoid/association'
require 'rails_admin/adapters/mongoid/bson'
require 'rails_admin/adapters/mongoid/property'
require 'rails_admin/adapters/mongoid/reflection'
require 'rails_admin/adapters/mongoid/repository'
require 'rails_admin/adapters/mongoid/statement_builder'
