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
      @@all_models ||= (
        possible_models = RailsAdmin::Config.included_models.map(&:to_s).presence || ([Rails.application] + Rails::Application::Railties.engines).map do |app|
          (app.paths['app/models'] + app.config.autoload_paths).map do |path|
            Dir.glob(app.root.join(path, "**/*.rb")).map do |filename|
              lchomp(filename, "#{app.root.join(path)}/").chomp('.rb').camelize  # app/models/module/class.rb => module/class.rb => module/class => Module::Class
            end
          end
        end.flatten
        excluded_models = (RailsAdmin::Config.excluded_models.map(&:to_s) + ['RailsAdmin::History'])
        (possible_models - excluded_models).uniq.sort{|x, y| x.to_s <=> y.to_s}.map{|model| lookup(model) }.compact
      )
    end

    # Given a string +model_name+, finds the corresponding model class
    def self.lookup(model_name)
      begin
        (model = model_name.constantize rescue nil) && model.is_a?(Class) && (superclasses(model).include?(ActiveRecord::Base) ? model : nil) || nil
      rescue LoadError
        Rails.logger.error "Error while loading '#{model_name}': #{$!}"
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
    
    def self.lchomp(base, arg) # yeah.. delete was probably safe, but never know.
      base.to_s.reverse.chomp(arg.to_s.reverse).reverse
    end
  end
end
