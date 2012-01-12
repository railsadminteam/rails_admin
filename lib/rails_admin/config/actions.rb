module RailsAdmin
  module Config
    module Actions
      
      class << self
        def all
          @@actions ||= [
            Dashboard.new,
            Index.new,
            Show.new,
            New.new,
            Edit.new,
            Index.new,
            Export.new,
            Delete.new,
            BulkDelete.new,
            HistoryShow.new,
            HistoryIndex.new,
          ]
        end
        
        def find custom_key
          all.find{ |a| a.custom_key == custom_key }
        end
        
        def root
          all.select &:root_level
        end
      
        def model
          all.select &:model_level
        end
      
        def object
          all.select &:object_level
        end
      
        def register(name, klass = nil)
          if klass == nil && name.kind_of?(Class)
            klass = name
            name = klass.to_s.demodulize.underscore.to_sym
          end
        
          instance_eval %{
            def #{name}(&block)
              action = #{klass}.new
              action.instance_eval &block if block
              (@@actions ||= []) << action
              action
            end
          }
        end
      end
    end
  end
end

require 'rails_admin/config/actions/base'
require 'rails_admin/config/actions/dashboard'
require 'rails_admin/config/actions/index'
require 'rails_admin/config/actions/show'
require 'rails_admin/config/actions/history_show'
require 'rails_admin/config/actions/history_index'
require 'rails_admin/config/actions/new'
require 'rails_admin/config/actions/edit'
require 'rails_admin/config/actions/export'
require 'rails_admin/config/actions/delete'
require 'rails_admin/config/actions/bulk_delete'

