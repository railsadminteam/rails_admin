require 'active_support/core_ext/string/inflections'
require 'rails_admin/config/sections/create'
require 'rails_admin/config/sections/list'
require 'rails_admin/config/sections/navigation'
require 'rails_admin/config/sections/update'

module RailsAdmin
  module Config
    # Sections describe different views in the RailsAdmin engine. Configurable sections are
    # list and navigation.
    #
    # Each section's class object can store generic configuration about that section (such as the
    # number of visible tabs in the main navigation), while the instances (accessed via model
    # configuration objects) store model specific configuration (such as the label of the
    # model to be used as the title in the main navigation tabs).
    module Sections
      def self.included(klass)
        # Register accessors for all the sections in this namespace
        constants.each do |name|
          section = "RailsAdmin::Config::Sections::#{name}".constantize
          name = name.to_s.downcase.to_sym
          klass.send(:define_method, name) do |&block|
            @sections = {} unless @sections
            unless @sections[name]
              @sections[name] = section.new(self)
            end
            @sections[name].instance_eval &block if block
            @sections[name]
          end
          # Register a shortcut to define the model's label for each section.
          klass.send(:define_method, "label_for_#{name}") do |*args, &block|
            send(name).label(block ? block : args[0])
          end
          # Register a shortcut to hide the model for each section.
          # NOTE: "hide_in_" is deprecated, use "hide_from_" instead.
          # FIXME: remove this after giving people an appropriate time
          # to change their code.
          klass.send(:define_method, "hide_in_#{name}") do |&block|
            send(name).visible(block ? proc { false == (instance_eval &block) } : false)
          end
          # Register a shortcut to hide the model for each section.
          klass.send(:define_method, "hide_from_#{name}") do |&block|
            send(name).visible(block ? proc { false == (instance_eval &block) } : false)
          end
          # Register a shortcut to show the model for each section.
          klass.send(:define_method, "show_in_#{name}") do |&block|
            send(name).visible(block || true)
          end
        end
      end
    end
  end
end
