module RailsAdmin
  module Fields
    @@registry = {}
  
    def self.factory(type)
      load(type).new
    end

    def self.register(type, klass)
      @@registry[type.to_sym] = klass
    end
  
    def self.load(type)
      @@registry[type.to_sym] or raise "Unsupported field @@type: #{@@type}"
    end
  
    # A base class for fields.
    class Base
      def self._column_css_class(field)
        @@column_css_class
      end

      def self._column_width(field)
        @@column_width
      end

      def self.searchable?
        send(:class_variable_get, "@@searchable")
      end

      def self.sortable?
        send(:class_variable_get, "@@sortable")
      end
    end

    class Boolean < Base
      cattr_accessor :column_css_class, :column_width, :searchable, :sortable
      cattr_reader :type
      @@column_css_class = "bool"
      @@column_width = 60
      @@searchable = false
      @@sortable = true
      @@type = :boolean
    end

    class Date < Base
      cattr_accessor :column_css_class, :column_width, :searchable, :sortable
      cattr_reader :type
      @@column_css_class = "date"
      @@column_width = 90
      @@searchable = false
      @@sortable = true
      @@type = :date
    end

    class Datetime < Base
      cattr_accessor :column_css_class, :column_width, :searchable, :sortable
      cattr_reader :type
      @@column_css_class = "dateTime"
      @@column_width = 170
      @@searchable = false
      @@sortable = true
      @@type = :datetime
    end

    class Float < Base
      cattr_accessor :column_css_class, :column_width, :searchable, :sortable
      cattr_reader :type
      @@column_css_class = "float"
      @@column_width = 110
      @@searchable = false
      @@sortable = true
      @@type = :float
    end

    class Integer < Base
      cattr_accessor :column_css_class, :column_width, :searchable, :sortable
      cattr_reader :type
      @@column_css_class = "int"
      @@column_width = 80
      @@searchable = false
      @@sortable = true
      @@type = :integer

      def self._column_css_class(field)
        if field == :id
          "id"
        elsif association = field.bindings[:abstract_model].belongs_to_associations.select{|a| a[:child_key].first == field}.first
          "smallString"
        else
          "int"
        end
      end

      def self._column_width()
        if field == :id
          46
        elsif association = field.bindings[:abstract_model].belongs_to_associations.select{|a| a[:child_key].first == field}.first
          180
        else
          80
        end
      end
    end

    class String < Base
      cattr_accessor :column_css_class, :column_width, :searchable, :sortable
      cattr_reader :type
      @@column_css_class = "smallString"
      @@column_width = 180
      @@searchable = true
      @@sortable = true
      @@type = :string
    
      def self._column_css_class(field)
        if field.length < 100
          "smallString"
        else
          "bigString"
        end
      end

      def self._column_width(field)
        if field.length < 100
          180
        else
          250
        end
      end
    end

    class Text < Base
      cattr_accessor :column_css_class, :column_width, :searchable, :sortable
      cattr_reader :type
      @@column_css_class = "text"
      @@column_width = 250
      @@searchable = true
      @@sortable = true
      @@type = :text
    end
  
    class Time < Base
      cattr_accessor :column_css_class, :column_width, :searchable, :sortable
      cattr_reader :type
      @@column_css_class = "time"
      @@column_width = 60
      @@searchable = false
      @@sortable = true
      @@type = :time
    end
  
    class Timestamp < Base
      cattr_accessor :column_css_class, :column_width, :searchable, :sortable
      cattr_reader :type
      @@column_css_class = "dateTime"
      @@column_width = 170
      @@searchable = false
      @@sortable = true
      @@type = :timestamp
    end

    class Virtual < Base
      cattr_accessor :column_css_class, :column_width, :searchable, :sortable
      cattr_reader :type
      @@column_css_class = "virtual"
      @@column_width = 170
      @@searchable = false
      @@sortable = false
      @@type = :virtual
    end
  
    constants.reject { |it| it == "Base" }.each do |it|
      @@registry[it.downcase.to_sym] = "RailsAdmin::Fields::#{it}".constantize
    end
  end
end