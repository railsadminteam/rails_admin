# frozen_string_literal: true

module RailsAdmin
  module Criteria
    # An attribute addressed by name, optionally reached through associations:
    # Path[:name], or Path[:team, :name] for the associated team's name.
    #
    # Fields say what to sort or search by in these terms and stop there. Each
    # adapter decides what that means for its store -- a qualified column and a
    # join, a two-step lookup by id, or a refusal. Before this, fields built
    # "table.column" strings themselves, which forced the Mongoid adapter to
    # take them apart again and guess what the prefix had meant.
    #
    # A path is not the same thing as one of those strings: its segments are
    # association and attribute names, not table and column names. Legacy
    # "table.column" values therefore stay as they are and are handed to the
    # store untouched.
    class Path
      attr_reader :segments

      def self.[](*segments)
        new(segments)
      end

      def initialize(segments)
        @segments = Array(segments).map(&:to_sym).freeze
      end

      # The attribute itself, the last segment of the path.
      def attribute
        segments.last
      end

      # The associations to travel through to reach the attribute, if any.
      def associations
        segments[0..-2]
      end

      # Whether the attribute belongs to the model the path starts from.
      def root?
        segments.size == 1
      end

      def to_a
        segments
      end

      def to_s
        segments.join('.')
      end

      def ==(other)
        other.is_a?(Path) && segments == other.segments
      end
      alias eql? ==

      def hash
        segments.hash
      end

      def inspect
        "#<RailsAdmin::Criteria::Path #{self}>"
      end
    end
  end
end
