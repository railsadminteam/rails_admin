module RailsAdmin
  class AbstractModel
    cattr_accessor :all
    attr_reader :adapter, :model_name

    class << self
      def reset
        @@all = nil
      end

      def all(adapter = nil)
        @@all ||= Config.models_pool.map{ |m| new(m) }.compact
        adapter ? @@all.select{|m| m.adapter == adapter} : @@all
      end

      alias_method :old_new, :new
      def new(m)
        m = m.is_a?(Class) ? m : m.constantize
        (am = old_new(m)).model && am.adapter ? am : nil
      rescue LoadError, NameError
        nil
      end

      @@polymorphic_parents = {}

      def polymorphic_parents(adapter, name)
        @@polymorphic_parents[adapter.to_sym] ||= {}.tap do |hash|
          all(adapter).each do |am|
            am.associations.select{|r| r[:as] }.each do |association|
              (hash[association[:as].to_sym] ||= []) << am.model
            end
          end
        end
        @@polymorphic_parents[adapter.to_sym][name.to_sym]
      end

      # For testing
      def reset_polymorphic_parents
        @@polymorphic_parents = {}
      end
    end

    def initialize(m)
      @model_name = m.to_s
      if m.ancestors.map(&:to_s).include?('ActiveRecord::Base') && !m.abstract_class?
        # ActiveRecord
        @adapter = :active_record
        require 'rails_admin/adapters/active_record'
        extend Adapters::ActiveRecord
      elsif m.ancestors.map(&:to_s).include?('Mongoid::Document')
        # Mongoid
        @adapter = :mongoid
        require 'rails_admin/adapters/mongoid'
        extend Adapters::Mongoid
      end
    end

    # do not store a reference to the model, does not play well with ActiveReload/Rails3.2
    def model
      @model_name.try :constantize
    end

    def config
      Config.model self
    end

    def to_param
      model.to_s.split("::").map(&:underscore).join("~")
    end

    def param_key
      model.to_s.split("::").map(&:underscore).join("_")
    end

    def pretty_name
      model.model_name.human
    end
  end
end
