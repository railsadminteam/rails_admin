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

        # orig regexp -- found 'class' even if it's within a comment or a quote
        filenames = Dir.glob(Rails.application.paths.app.models.collect { |path| File.join(path, "**/*.rb") })
        class_names = []
        filenames.each do |filename|
          class_names += File.read(filename).scan(/class ([\w\d_\-:]+)/).flatten
        end
        possible_models = Module.constants | class_names
        #Rails.logger.info "possible_models: #{possible_models.inspect}"
        add_models(possible_models, excluded_models)

        #Rails.logger.info "final models: #{@models.map(&:model).inspect}"
        @models.sort!{|x, y| x.model.to_s <=> y.model.to_s}
      end

      @models
    end

    def self.add_models(possible_models=[], excluded_models=[])
      possible_models.each do |possible_model_name|
        next if excluded_models.include?(possible_model_name)
        #Rails.logger.info "possible_model_name: #{possible_model_name.inspect}"
        add_model(possible_model_name)
      end
    end

    def self.add_model(model_name)
      model = lookup(model_name,false)
      @models << new(model) if model
    end

    # Given a string +model_name+, finds the corresponding model class
    def self.lookup(model_name,raise_error=true)
      begin
        model = model_name.constantize
      rescue NameError
        #Rails.logger.info "#{model_name} wasn't a model"
        raise "RailsAdmin could not find model #{model_name}" if raise_error
        return nil
      end

      if model.is_a?(Class) && superclasses(model).include?(ActiveRecord::Base)
        #Rails.logger.info "#{model_name} is a model"
        model
      else
        #Rails.logger.info "#{model_name} is NOT a model"
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