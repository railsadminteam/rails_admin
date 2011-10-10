require 'rails_admin/config/fields/group'

module RailsAdmin
  module Config
    module HasGroups
      # Access fields by their group
      def fields_of_group(group, &block)
        selected = @fields.select {|f| group == f.group }
        if block
          selected.each {|f| f.instance_eval &block }
        end
        selected
      end

      # Accessor for a group
      #
      # If group with given name does not yet exist it will be created. If a
      # block is passed it will be evaluated in the context of the group
      def group(name, &block)
        group = @groups.find {|g| name == g.name }
        if group.nil?
          group = (@groups << RailsAdmin::Config::Fields::Group.new(self, name)).last
        end
        group.instance_eval &block if block
        group
      end

      # Reader for groups
      def groups
        @groups
      end

      # Reader for groups that are marked as visible
      def visible_groups
        groups.select {|g| g.visible? }
      end
    end
  end
end
