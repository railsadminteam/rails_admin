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
    end

    def initialize(m)
      @model_name = m.to_s
      # ActiveRecord
      if m.ancestors.map(&:to_s).include?('ActiveRecord::Base') && !m.abstract_class?
        @adapter = :active_record
        require 'rails_admin/adapters/active_record'
        extend Adapters::ActiveRecord
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
