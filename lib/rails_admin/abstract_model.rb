module RailsAdmin
  class AbstractModel
    cattr_accessor :all
    attr_reader :model, :adapter
    
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
      @model = m
      # ActiveRecord
      if @model.ancestors.map(&:to_s).include?('ActiveRecord::Base') && !@model.abstract_class?
        @adapter = :active_record
        require 'rails_admin/adapters/active_record'
        extend Adapters::ActiveRecord
      end
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
