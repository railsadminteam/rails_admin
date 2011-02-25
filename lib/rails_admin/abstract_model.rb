require 'active_support/core_ext/string/inflections'
require 'rails_admin/generic_support'

module RailsAdmin
  class AbstractModel

    @models = []

    # Returns all models for a given Rails app
    def self.all
      if @models.empty?
        excluded_models = RailsAdmin::Config.excluded_models.map(&:to_s)
        excluded_models << ['History']

        Dir.glob(Rails.application.paths.app.models.collect { |path| File.join(path, "**/*.rb") }).each do |filename|
          File.read(filename).scan(/class ([\w\d_\-:]+)/).flatten.each do |model_name|
            add_model(model_name) unless excluded_models.include?(model_name)
          end
        end

        @models.sort!{|x, y| x.model.to_s <=> y.model.to_s}
      end

      @models
    end

    def self.add_model(model_name)
      model = lookup(model_name)
      @models << new(model) if model
    end

    # Given a string +model_name+, finds the corresponding model class
    def self.lookup(model_name)
      begin
        model = model_name.constantize
      rescue NameError
        raise "RailsAdmin could not find model #{model_name}"
      end

      if superclasses(model).include?(ActiveRecord::Base)
        model
      else
        nil
      end
    end

    def initialize(model)
      model = self.class.lookup(model.to_s.camelize) unless model.is_a?(Class)
      @model_name = model.name
      self.extend(GenericSupport)
      ### TODO more ORMs support
      require 'rails_admin/adapters/active_record'
      self.extend(RailsAdmin::Adapters::ActiveRecord)
    end

    def model
      @model_name.constantize
    end

    private

    def self.superclasses(klass)
      superclasses = []
      while klass
        superclasses << klass.superclass if klass && klass.superclass
        klass = klass.superclass
      end
      superclasses
    end
  end
end