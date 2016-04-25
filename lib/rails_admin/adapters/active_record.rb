require 'active_record'
require 'rails_admin/adapters/active_record/abstract_object'
require 'rails_admin/adapters/active_record/association'
require 'rails_admin/adapters/active_record/property'

module RailsAdmin
  module Adapters
    module ActiveRecord
      DISABLED_COLUMN_TYPES = [:tsvector, :blob, :binary, :spatial, :hstore, :geometry]

      def new(params = {})
        AbstractObject.new(model.new(params))
      end

      def get(id)
        return unless object = model.where(primary_key => id).first
        AbstractObject.new object
      end

      def scoped
        model.all
      end

      def first(options = {}, scope = nil)
        all(options, scope).first
      end

      def all(options = {}, scope = nil)
        scope ||= scoped
        scope = scope.includes(options[:include]) if options[:include]
        scope = scope.limit(options[:limit]) if options[:limit]
        scope = scope.where(primary_key => options[:bulk_ids]) if options[:bulk_ids]
        scope = query_scope(scope, options[:query]) if options[:query]
        scope = filter_scope(scope, options[:filters]) if options[:filters]
        if options[:page] && options[:per]
          scope = scope.send(Kaminari.config.page_method_name, options[:page]).per(options[:per])
        end
        scope = scope.reorder("#{options[:sort]} #{options[:sort_reverse] ? 'asc' : 'desc'}") if options[:sort]
        scope
      end

      def count(options = {}, scope = nil)
        all(options.merge(limit: false, page: false), scope).count(:all)
      end

      def destroy(objects)
        Array.wrap(objects).each(&:destroy)
      end

      def associations
        model.reflect_on_all_associations.collect do |association|
          Association.new(association, model)
        end
      end

      def properties
        columns = model.columns.reject do |c|
          c.type.blank? ||
            DISABLED_COLUMN_TYPES.include?(c.type.to_sym) ||
            c.try(:array)
        end
        columns.collect do |property|
          Property.new(property, model)
        end
      end

      delegate :primary_key, :table_name, to: :model, prefix: false

      def encoding
        case ::ActiveRecord::Base.connection_config[:adapter]
          when 'postgresql'
            ::ActiveRecord::Base.connection.select_one("SELECT ''::text AS str;").values.first.encoding
          when 'mysql2'
            ::ActiveRecord::Base.connection.instance_variable_get(:@connection).encoding
          else
            ::ActiveRecord::Base.connection.select_one("SELECT '' AS str;").values.first.encoding
        end
      end

      def embedded?
        false
      end

      def cyclic?
        false
      end

      def adapter_supports_joins?
        true
      end

      class WhereBuilder
        def initialize(scope)
          @statements = []
          @values = []
          @tables = []
          @scope = scope
        end

        def add(field, value, operator)
          field.searchable_columns.flatten.each do |column_infos|
            if value.is_a?(Array)
              value = value.map { |v| field.parse_value(v) }
            else
              value = field.parse_value(value)
            end
            statement, value1, value2 = StatementBuilder.new(column_infos[:column], column_infos[:type], value, operator).to_statement
            @statements << statement if statement.present?
            @values << value1 unless value1.nil?
            @values << value2 unless value2.nil?
            table, column = column_infos[:column].split('.')
            @tables.push(table) if column
          end
        end

        def build
          scope = @scope.where(@statements.join(' OR '), *@values)
          scope = scope.references(*(@tables.uniq)) if @tables.any?
          scope
        end
      end

      def query_scope(scope, query, fields = config.list.fields.select(&:queryable?))
        wb = WhereBuilder.new(scope)
        fields.each do |field|
          wb.add(field, field.parse_value(query), field.search_operator)
        end
        # OR all query statements
        wb.build
      end

      # filters example => {"string_field"=>{"0055"=>{"o"=>"like", "v"=>"test_value"}}, ...}
      # "0055" is the filter index, no use here. o is the operator, v the value
      def filter_scope(scope, filters, fields = config.list.fields.select(&:filterable?))
        filters.each_pair do |field_name, filters_dump|
          filters_dump.each do |_, filter_dump|
            wb = WhereBuilder.new(scope)
            field = fields.detect { |f| f.name.to_s == field_name }
            value = parse_field_value(field, filter_dump[:v])

            wb.add(field, value, (filter_dump[:o] || 'default'))
            # AND current filter statements to other filter statements
            scope = wb.build
          end
        end
        scope
      end

      def build_statement(column, type, value, operator)
        StatementBuilder.new(column, type, value, operator).to_statement
      end

      class StatementBuilder < RailsAdmin::AbstractModel::StatementBuilder
        protected

        def unary_operators
          {
            '_blank' => ["(#{@column} IS NULL OR #{@column} = '')"],
            '_present' => ["(#{@column} IS NOT NULL AND #{@column} != '')"],
            '_null' => ["(#{@column} IS NULL)"],
            '_not_null' => ["(#{@column} IS NOT NULL)"],
            '_empty' => ["(#{@column} = '')"],
            '_not_empty' => ["(#{@column} != '')"],
          }
        end

        private

        def range_filter(min, max)
          if min && max
            ["(#{@column} BETWEEN ? AND ?)", min, max]
          elsif min
            ["(#{@column} >= ?)", min]
          elsif max
            ["(#{@column} <= ?)", max]
          end
        end

        def build_statement_for_type
          case @type
            when :jsonb, :json then
              build_statement_for_jsonb
            when :boolean then
              build_statement_for_boolean
            when :integer, :decimal, :float then
              build_statement_for_integer_decimal_or_float
            when :string, :text then
              build_statement_for_string_or_text
            when :enum then
              build_statement_for_enum
            when :belongs_to_association then
              build_statement_for_belongs_to_association
          end
        end

        def build_statement_for_jsonb
          return unless ar_adapter == 'postgresql'
          return unless @value

          extract_operator_as_text = '#>>' #get path as text
          extract_operator_as_jsonb = '#>' #get path
          json_path = Array.wrap(@value[:json_field_name].split('.')).reject(&:blank?)
          return if json_path.blank?

          selection_as_text = "(#{@column}#{extract_operator_as_text}'{#{json_path.join(',')}}')"
          selection_as_jsonb = "(#{@column}#{extract_operator_as_jsonb}'{#{json_path.join(',')}}')"
          json_value = Array.wrap(@value[:json_field_value])

          case @operator
            when 'is', '=' then
              return ["(#{selection_as_text}::boolean IS NOT NULL AND #{selection_as_text}::boolean = ?::boolean)", json_value.first] if %w{true false}.include?(json_value.first.downcase)
              return ["(#{selection_as_text}::numeric IS NOT NULL AND #{selection_as_text}::numeric = ?)", json_value.first.to_f] if (!!Float(json_value.first) rescue false)
              return ["(#{selection_as_text}::numeric IS NOT NULL AND #{selection_as_text}::numeric = ?)", json_value.first.to_i] if (!!Integer(json_value.first) rescue false)
              return ["(#{selection_as_text} = ?)", json_value.first]
            when 'is_present' then
              ["(#{selection_as_text} IS NOT NULL)"]
            when 'is_blank' then
              ["(#{selection_as_text} IS NULL)"]
            when 'like', 'contains' then
              ["(#{selection_as_text} ILIKE ?)", '%'+json_value.first+'%']
            when 'starts_with' then
              ["(#{selection_as_text} ILIKE ?)", json_value.first+'%']
            when 'ends_with' then
              ["(#{selection_as_text} ILIKE ?)", '%'+json_value.first]
            when 'in' then
              ["(#{selection_as_text} IN (?))", json_value.first.split(',').map(&:strip).reject(&:blank?)]
            when 'is_true' then
              ["(#{selection_as_text}::boolean)", true]
            when 'is_false' then
              ["(NOT #{selection_as_text}::boolean)", false]
            when 'between' then
              json_value = json_value.map { |n| Float(n) rescue nil }.compact.uniq
              return if json_value.size < 2
              min = json_value.min
              max = json_value.max
              ["(#{selection_as_text}::float BETWEEN ? AND ?)", min, max]
            when 'over' then
              num = json_value.first.try { |n| Float(n) }
              return unless num
              ["(#{selection_as_text}::float >= ?)", num]
            when 'under' then
              num = json_value.first.try { |n| Float(n) }
              return unless num
              ["(#{selection_as_text}::float <= ?)", num]
            when 'includes' then
              vals = json_value.first.split(',').map(&:strip).reject(&:blank?)
              ["(CASE jsonb_typeof(#{selection_as_jsonb}::jsonb) WHEN 'array' THEN #{selection_as_jsonb} @> jsonb_build_array(?) ELSE false END)", json_value.first.split(',').map(&:strip).reject(&:blank?)]
            when 'empty' then
              ["(CASE jsonb_typeof(#{selection_as_jsonb}::jsonb) WHEN 'array' THEN jsonb_array_length(#{selection_as_jsonb}::jsonb) <= ? ELSE false END)", 0]
            when 'not_empty' then
              ["(CASE jsonb_typeof(#{selection_as_jsonb}::jsonb) WHEN 'array' THEN jsonb_array_length(#{selection_as_jsonb}::jsonb) > ? ELSE false END)", 0]
            else
          end
        end

        def build_statement_for_boolean
          return ["(#{@column} IS NULL OR #{@column} = ?)", false] if %w(false f 0).include?(@value)
          return ["(#{@column} = ?)", true] if %w(true t 1).include?(@value)
        end

        def column_for_value(value)
          ["(#{@column} = ?)", value]
        end

        def column_for_multiple_values(values)
          return if values.blank?
          ["(#{@column} IN (?))", Array.wrap(values)]
        end

        def build_statement_for_belongs_to_association
          return if @value.blank?
          ["(#{@column} = ?)", @value.to_i] if @value.to_i.to_s == @value
        end

        def column_for_single_string_or_text(value)
          return if value.blank?
          value = begin
            case @operator
              when 'like'
                "%#{value.downcase}%"
              when 'starts_with'
                "#{value.downcase}%"
              when 'ends_with'
                "%#{value.downcase}"
              when 'is', '='
                "#{value.downcase}"
              else
                return
            end
          end

          if ar_adapter == 'postgresql'
            ["(#{@column} ILIKE ?)", value]
          else
            ["(LOWER(#{@column}) LIKE ?)", value]
          end
        end

        def column_for_multiple_string_or_text(values)
          return if values.blank?
          ["(LOWER(#{@column}) IN (?))", Array.wrap(values)]
        end

        def build_statement_for_enum
          return if @value.blank?
          ["(#{@column} IN (?))", Array.wrap(@value)]
        end

        def ar_adapter
          ::ActiveRecord::Base.connection.adapter_name.downcase
        end
      end
    end
  end
end
