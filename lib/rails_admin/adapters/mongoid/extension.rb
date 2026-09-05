# frozen_string_literal: true

module RailsAdmin
  module Adapters
    module Mongoid
      module Extension
        extend ActiveSupport::Concern

        included do
          class_attribute :nested_attributes_options
          self.nested_attributes_options = {}
          class << self
            def rails_admin(&block)
              RailsAdmin.config(self, &block)
            end

            alias_method :accepts_nested_attributes_for_without_rails_admin, :accepts_nested_attributes_for
            alias_method :accepts_nested_attributes_for, :accepts_nested_attributes_for_with_rails_admin
          end
        end

        def safe_send(value)
          if attributes.detect { |k, _v| k.to_s == value.to_s }
            read_attribute(value)
          else
            send(value)
          end
        end

        module ClassMethods
          # Keeps the options of accepts_nested_attributes_for, because Mongoid
          # does not (checked against 9.1). It hands them to the block that
          # defines the setter and keeps nothing: Model.nested_attributes only
          # maps "xs_attributes" to its setter, and the association carries the
          # autosave flag but nothing else.
          #
          # RailsAdmin needs allow_destroy to decide whether a nested form
          # offers to remove an existing record. Guessing it wrong is not
          # something anyone would notice: Mongoid takes _destroy out of the
          # attributes before finding out it is not allowed to destroy, so the
          # record is updated like any other and the row the user removed is
          # simply still there after saving, with nothing raised.
          #
          # The defaults are ActiveRecord's own, so that nested_options has the
          # same shape whichever adapter answered it.
          def accepts_nested_attributes_for_with_rails_admin(*args)
            options = args.extract_options!
            args.each do |arg|
              nested_attributes_options[arg.to_sym] = options.reverse_merge(allow_destroy: false, update_only: false)
            end
            args << options
            accepts_nested_attributes_for_without_rails_admin(*args)
          end
        end
      end
    end
  end
end
