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
        m = m.constantize unless m.is_a?(Class)
        (am = old_new(m)).model && am.adapter ? am : nil
      rescue LoadError, NameError
        puts "[RailsAdmin] Could not load model #{m}, assuming model is non existing. (#{$!})" unless Rails.env.test?
        nil
      end

      @@polymorphic_parents = {}

      def polymorphic_parents(adapter, model_name, name)
        @@polymorphic_parents[adapter.to_sym] ||= {}.tap do |hash|
          all(adapter).each do |am|
            am.associations.select{|r| r[:as] }.each do |association|
              (hash[[association[:model_proc].call.to_s.underscore, association[:as]].join('_').to_sym] ||= []) << am.model
            end
          end
        end
        @@polymorphic_parents[adapter.to_sym][[model_name.to_s.underscore, name].join('_').to_sym]
      end

      # For testing
      def reset_polymorphic_parents
        @@polymorphic_parents = {}
      end
    end

    def initialize(model_or_model_name)
      @model_name = model_or_model_name.to_s
      ancestors = model.ancestors.map(&:to_s)
      if ancestors.include?('ActiveRecord::Base') && !model.abstract_class?
        initialize_active_record
      elsif ancestors.include?('Mongoid::Document')
        initialize_mongoid
      end
    end

    # do not store a reference to the model, does not play well with ActiveReload/Rails3.2
    def model
      @model_name.constantize
    end

    def to_s
      model.to_s
    end

    def config
      Config.model self
    end

    def to_param
      @model_name.split("::").map(&:underscore).join("~")
    end

    def param_key
      @model_name.split("::").map(&:underscore).join("_")
    end

    def pretty_name
      model.model_name.human
    end

    def where(conditions)
      model.where(conditions)
    end

    def each_associated_children(object)
      associations.each do |association|
        case association[:type]
        when :has_one
          if child = object.send(association[:name])
            yield(association, child)
          end
        when :has_many
          object.send(association[:name]).each do |child|
            yield(association, child)
          end
        end
      end
    end

    private

    def initialize_active_record
      @adapter = :active_record
      require 'rails_admin/adapters/active_record'
      extend Adapters::ActiveRecord
    end

    def initialize_mongoid
      @adapter = :mongoid
      require 'rails_admin/adapters/mongoid'
      extend Adapters::Mongoid
    end

    class StatementBuilder
      def initialize(column, type, value, operator)
        @column = column
        @type = type
        @value = value
        @operator = operator
      end

      def to_statement
        return if [@operator, @value].any? { |v| v == '_discard' }

        unary_operators[@operator] || unary_operators[@value] ||
          build_statement_for_type
      end

      protected

      def get_filtering_duration
        date_format = I18n.t("admin.misc.filter_date_format", :default => I18n.t("admin.misc.filter_date_format", :locale => :en)).gsub('dd', '%d').gsub('mm', '%m').gsub('yy', '%Y')
        case @operator
        when 'between'
          start_date = @value[1].present? && Date.strptime(@value[1], date_format)
          end_date   = @value[2].present? && Date.strptime(@value[2], date_format)
        when 'today'
          start_date = end_date = Date.today
        when 'yesterday'
          start_date = end_date = Date.yesterday
        when 'this_week'
          start_date = Date.today.beginning_of_week
          end_date   = Date.today.end_of_week
        when 'last_week'
          start_date = 1.week.ago.to_date.beginning_of_week
          end_date   = 1.week.ago.to_date.end_of_week
        else # default
          start_date = (Date.strptime(Array.wrap(@value).first, date_format) rescue false)
          end_date   = (Date.strptime(Array.wrap(@value).first, date_format) rescue false)
        end
        [start_date, end_date]
      end

      def build_statement_for_type
        raise "You must override build_statement_for_type in your StatementBuilder"
      end

      def unary_operators
        raise "You must override unary_operators in your StatementBuilder"
      end
    end
  end
end
