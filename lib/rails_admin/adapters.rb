# frozen_string_literal: true

module RailsAdmin
  # Which adapters exist, and how a model is matched to one of them.
  #
  # An adapter is a name, a way of telling whether a model belongs to it, and
  # the two classes that implement it -- a Reflection and a Repository. Adding
  # one from outside the gem is a call to +register+:
  #
  #   RailsAdmin::Adapters.register(
  #     :sequel,
  #     reflection: RailsAdmin::Adapters::Sequel::Reflection,
  #     repository: RailsAdmin::Adapters::Sequel::Repository,
  #   ) { |model| model < ::Sequel::Model }
  #
  # The most recently registered adapter is asked first, so a registration can
  # take over from a built-in one.
  module Adapters
    class Registration
      attr_reader :name

      # +reflection+ and +repository+ may be classes, or the names of classes as
      # strings together with +require_path+. The built-in adapters name theirs,
      # because loading an adapter loads its ORM and an application must not have
      # the ORM it does not use required on its behalf.
      def initialize(name, reflection:, repository:, require_path: nil, &detector)
        @name = name
        @reflection = reflection
        @repository = repository
        @require_path = require_path
        @detector = detector
      end

      # Whether this adapter handles the given model. Called for every model in
      # the pool, before anything is loaded, so it must not load the ORM either
      # -- which is why the built-in detectors match on ancestor names rather
      # than on the ancestors themselves.
      def matches?(model)
        @detector.call(model)
      end

      def reflection
        @reflection = resolve(@reflection)
      end

      def repository
        @repository = resolve(@repository)
      end

    private

      def resolve(klass)
        return klass unless klass.is_a?(::String)

        require @require_path if @require_path
        klass.constantize
      end
    end

    class << self
      def register(name, **options, &detector)
        registrations.unshift(Registration.new(name, **options, &detector))
        name
      end

      def registrations
        @registrations ||= []
      end

      def detect(model)
        registrations.detect { |registration| registration.matches?(model) }
      end
    end

    register(
      :active_record,
      require_path: 'rails_admin/adapters/active_record',
      reflection: 'RailsAdmin::Adapters::ActiveRecord::Reflection',
      repository: 'RailsAdmin::Adapters::ActiveRecord::Repository',
    ) do |model|
      model.ancestors.collect(&:to_s).include?('ActiveRecord::Base') &&
        !model.abstract_class? && model.table_exists?
    end

    register(
      :mongoid,
      require_path: 'rails_admin/adapters/mongoid',
      reflection: 'RailsAdmin::Adapters::Mongoid::Reflection',
      repository: 'RailsAdmin::Adapters::Mongoid::Repository',
    ) do |model|
      model.ancestors.collect(&:to_s).include?('Mongoid::Document')
    end
  end
end
