require 'active_support/core_ext/string/inflections'
require 'rails_admin/generic_support'

module RailsAdmin
  class AbstractModel
    cattr_accessor :all_models, :all_abstract_models
    @@all_models = nil
    @@all_abstract_models = nil
    # Returns all models for a given Rails app

    # self.all_abstract_models
    def self.all
      @@all_abstract_models ||= all_models.map{ |model| new(model) }
    end

    def self.all_models
      unless @@all_models
        @@all_models = []
        if RailsAdmin::Config.included_models.any?
          # Whitelist approach, use only models explicitly listed
          possible_models = RailsAdmin::Config.included_models.map(&:to_s)
        else
          # orig regexp -- found 'class' even if it's within a comment or a quote
          filenames = Dir.glob(Rails.application.paths["app/models"].collect { |path| File.join(Rails.root, path, "**/*.rb") })

          class_names = []
          filenames.each do |filename|
            class_names += File.read(filename).scan(/class ([\w\d_\-:]+)/).flatten
          end
          possible_models = class_names
        end

        excluded_models = RailsAdmin::Config.excluded_models.map(&:to_s)
        excluded_models << ['History']

        add_models(possible_models, excluded_models)

        @@all_models.sort!{|x, y| x.to_s <=> y.to_s}
      end
      @@all_models
    end

    def self.add_models(possible_models=[], excluded_models=[])
      possible_models.each do |possible_model_name|
        next if excluded_models.include?(possible_model_name)
        add_model(possible_model_name)
      end
    end

    def self.add_model(model_name)
      model = lookup(model_name,false)
      @@all_models << model if model
    end

    # Given a string +model_name+, finds the corresponding model class
    def self.lookup(model_name,raise_error=true)
      begin
        model = model_name.constantize
      rescue NameError
        raise "RailsAdmin could not find model #{model_name}" if raise_error
        return nil
      end

      if model.is_a?(Class) && superclasses(model).include?(ActiveRecord::Base)
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
