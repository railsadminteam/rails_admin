module RailsAdmin
  module Config
    module Actions

      class << self
        def all(scope = nil, bindings = {})
          if scope.is_a?(Hash)
            bindings = scope
            scope = :all
          end
          scope ||= :all
          init_actions!
          actions = case scope
          when :all
            @@actions
          when :root
            @@actions.select(&:root?)
          when :collection
            @@actions.select(&:collection?)
          when :bulkable
            @@actions.select(&:bulkable?)
          when :member
            @@actions.select(&:member?)
          end
          actions = actions.map{ |action| action.with(bindings) }
          bindings[:controller] ? actions.select(&:visible?) : actions
        end

        def find custom_key, bindings = {}
          init_actions!
          action = @@actions.find{ |a| a.custom_key == custom_key }.try(:with, bindings)
          bindings[:controller] ? (action.try(:visible?) && action || nil) : action
        end

        def collection key, parent_class = :base, &block
          add_action key, parent_class, :collection, &block
        end

        def member key, parent_class = :base, &block
          add_action key, parent_class, :member, &block
        end

        def root key, parent_class = :base, &block
          add_action key, parent_class, :root, &block
        end

        def add_action key, parent_class, parent, &block
          a = "RailsAdmin::Config::Actions::#{parent_class.to_s.camelize}".constantize.new
          a.instance_eval(%{
            #{parent} true
            def key
              :#{key}
            end
          })
          a.instance_eval(&block) if block
          unless a.custom_key.in?((@@actions || []).map(&:custom_key))
            (@@actions ||= []) << a
          else
            raise "Action #{a.custom_key} already exist. Please change its custom key"
          end
        end

        def reset
          @@actions = nil
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
              unless action.custom_key.in?((@@actions || []).map(&:custom_key))
                (@@actions ||= []) << action
              else
                raise "Action \#{action.custom_key} already exist. Please change its custom key"
              end
            end
          }
        end

        private

        def init_actions!
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

