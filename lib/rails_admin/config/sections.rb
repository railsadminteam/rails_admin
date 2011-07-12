require 'active_support/core_ext/string/inflections'
require 'rails_admin/config/sections/create'
require 'rails_admin/config/sections/list'
require 'rails_admin/config/sections/navigation'
require 'rails_admin/config/sections/update'
require 'rails_admin/config/sections/export'
require 'rails_admin/config/sections/show'

module RailsAdmin
  module Config
    # Sections describe different views in the RailsAdmin engine. Configurable sections are
    # list and navigation.
    #
    # Each section's class object can store generic configuration about that section (such as the
    # number of visible tabs in the main navigation), while the instances (accessed via model
    # configuration objects) store model specific configuration (such as the visibility of the
    # model).
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
          klass.send(:define_method, "label_for_#{name}") do
            # TODO: Remove this warning in the next release, after people have updated their applications
            $stderr.puts("WARNING: label_for_#{name} has been removed. This configuration will be ignored. Model names can be configured with 'label' and section-specific names are no longer supported. See README for details.")
          end
          # Register a shortcut to hide the model for each section.
          klass.send(:define_method, "hide_from_#{name}") do |&block|
            # TODO: Remove this warning in the next release, after people have updated their applications
            $stderr.puts("WARNING: hide_from_#{name} has been removed. This configuration will be ignored. Model visibility can be configured with 'hide', 'show' and 'visibility'. Section-specific visibility is no longer supported. See README for details.")
          end
          # Register a shortcut to show the model for each section.
          klass.send(:define_method, "show_in_#{name}") do |&block|
            # TODO: Remove this warning in the next release, after people have updated their applications
            $stderr.puts("WARNING: show_in_#{name} has been removed. This configuration will be ignored. Model visibility can be configured with 'hide', 'show' and 'visibility'. Section-specific visibility is no longer supported. See README for details.")
          end
        end
      end
    end
  end
end
