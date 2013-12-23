require 'rails_admin/config/fields/group'

module RailsAdmin
  module Config
    module HasGroups
      # Accessor for a group
      #
      # If group with given name does not yet exist it will be created. If a
      # block is passed it will be evaluated in the context of the group
      def group(name, &block)
        group = parent.groups.detect { |g| name == g.name }
        group ||= (parent.groups << RailsAdmin::Config::Fields::Group.new(self, name)).last
        group.tap { |g| g.section = self }.instance_eval(&block) if block
        group
      end

      # Reader for groups that are marked as visible
      def visible_groups
        parent.groups.map { |group| group.section = self; group.with(bindings) }.select(&:visible?).select { |group| group.visible_fields.present? } # rubocop:disable Semicolon
      end
    end
  end
end
