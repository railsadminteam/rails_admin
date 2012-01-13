module RailsAdmin
  module Config
    module Actions
      
      class << self
        def all(bindings)
          @@actions ||= [
            Dashboard.new,
            Index.new,
            Show.new,
            New.new,
            Edit.new,
            Export.new,
            Delete.new,
            BulkDelete.new,
            HistoryShow.new,
            HistoryIndex.new,
            ShowInApp.new,
          ]
          @@actions.map{ |action| action.with(bindings) }.select(&:visible?)
        end
        
        def find custom_key, bindings
          all(bindings).find{ |a| a.custom_key == custom_key }
        end
        
        def root bindings
          all(bindings).select &:root_level
        end
      
        def model bindings
          all(bindings).select &:model_level
        end
      
        def object bindings
          all(bindings).select &:object_level
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
require 'rails_admin/config/actions/show_in_app'
require 'rails_admin/config/actions/history_show'
require 'rails_admin/config/actions/history_index'
require 'rails_admin/config/actions/new'
require 'rails_admin/config/actions/edit'
require 'rails_admin/config/actions/export'
require 'rails_admin/config/actions/delete'
require 'rails_admin/config/actions/bulk_delete'

