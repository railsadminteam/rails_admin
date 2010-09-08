require 'rails_admin/generic_support'

module RailsAdmin
  class AbstractModel
    # Returns all models for a given Rails app
    def self.all
      @models = []
      str = ""
      devideModel =  Devise.mappings.keys[0].to_param.capitalize
      historyModel = "History"
      
      Dir.glob(Rails.root.join("app/models/**/*.rb")).each do |filename|
        File.read(filename).scan(/class ([\w\d_\-:]+)/).flatten.each do |model_name|
          if model_name != devideModel and model_name != historyModel
            add_model(model_name)
          end
        end
      end

      @models.sort!{|x, y| x.model.to_s <=> y.model.to_s}
    end

    def self.add_model(model_name)
      model = lookup(model_name)
      @models << new(model) if model
    end

    # Given a string +model_name+, finds the corresponding model class
    def self.lookup(model_name)
      begin
        # TODO: Should probably require the right part of ActiveSupport for this
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

    attr_accessor :model

    def initialize(model)
      model = self.class.lookup(model.to_s.camelize) unless model.is_a?(Class)
      @model = model
      self.extend(GenericSupport)
      ### TODO more ORMs support
      require 'rails_admin/active_record_support'
      self.extend(ActiverecordSupport)
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
