# frozen_string_literal: true

require 'active_record'

module RailsAdmin
  module Adapters
    module ActiveRecord
      DISABLED_COLUMN_TYPES = %i[tsvector blob binary spatial hstore geometry].freeze
    end
  end
end

require 'rails_admin/adapters/active_record/association'
require 'rails_admin/adapters/active_record/object_extension'
require 'rails_admin/adapters/active_record/property'
require 'rails_admin/adapters/active_record/reflection'
require 'rails_admin/adapters/active_record/repository'
require 'rails_admin/adapters/active_record/statement_builder'
require 'rails_admin/adapters/active_record/where_builder'
