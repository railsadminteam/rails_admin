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
      return @@all_models if @@all_models
      
      raise Exception.new('Nested call to AbstractModel.all_models, this should NEVER happen. Please post stack to github') if @semaphore
      
      @semaphore = true
      
      if RailsAdmin::Config.included_models.any?
        # Whitelist approach, use only models explicitly listed
        possible_models = RailsAdmin::Config.included_models.map(&:to_s)
      else
        filenames = Dir.glob(Rails.application.paths["app/models"].map { |path| File.join(Rails.root, path, "**/*.rb") })
        Rails::Application::Railties.engines.each do |engine|
          engine.paths['app/models'].each do |path|
            filenames += Dir.glob(engine.root.join(path, "**/*.rb"))
          end
        end
    
        class_names = []
        filenames.each do |filename|
          class_names += File.read(filename).scan(/class ([\w\d_\-:]+)/).flatten
        end
        possible_models = class_names
      end

      excluded_models = RailsAdmin::Config.excluded_models.map(&:to_s)
      excluded_models << ['History']
      
      models = (possible_models - excluded_models).uniq
      models.sort!{|x, y| x.to_s <=> y.to_s}
      @@all_models = models.map{|model| lookup model }.compact
      @semaphore = false
      @@all_models
    end

    # Given a string +model_name+, finds the corresponding model class
    def self.lookup(model_name)
      (model = model_name.constantize rescue nil) && (superclasses(model).include?(ActiveRecord::Base) ? model : nil)
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
