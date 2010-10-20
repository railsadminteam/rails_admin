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
      @@registry[type.to_sym] or raise "Unsupported field type: #{@type}"
    end
  
    # A base class for fields.
    class Base
      class << self
        attr_accessor :column_css_class, :column_width, :searchable, :sortable
        attr_reader :type
      end

      def self.searchable?
        @searchable
      end

      def self.sortable?
        @sortable
      end
    end

    class Boolean < Base
      @column_css_class = "bool"
      @column_width = 60
      @searchable = false
      @sortable = true
      @type = :boolean
    end

    class Date < Base
      @column_css_class = "date"
      @column_width = 90
      @searchable = false
      @sortable = true
      @type = :date
    end

    class Datetime < Base
      @column_css_class = "dateTime"
      @column_width = 170
      @searchable = false
      @sortable = true
      @type = :datetime
    end

    class Float < Base
      @column_css_class = "float"
      @column_width = 110
      @searchable = false
      @sortable = true
      @type = :float
    end

    class Integer < Base
      @column_css_class = "int"
      @column_width = 80
      @searchable = false
      @sortable = true
      @type = :integer
    end
    
    class Serial < Integer
      @column_css_class = "id"
      @column_width = 46
      @searchable = false
      @sortable = true
      @type = :integer
    end

    class String < Base
      @column_css_class = "bigString"
      @column_width = 250
      @searchable = true
      @sortable = true
      @type = :string
    end
    
    class SmallString < Base
      @column_css_class = "smallString"
      @column_width = 180
      @searchable = true
      @sortable = true
      @type = :string
    end

    class Text < Base
      @column_css_class = "text"
      @column_width = 250
      @searchable = true
      @sortable = true
      @type = :text
    end
  
    class Time < Base
      @column_css_class = "time"
      @column_width = 60
      @searchable = false
      @sortable = true
      @type = :time
    end
  
    class Timestamp < Base
      @column_css_class = "dateTime"
      @column_width = 170
      @searchable = false
      @sortable = true
      @type = :timestamp
    end

    constants.reject { |it| it == "Base" }.each do |it|
      @@registry[it.to_s.underscore.to_sym] = "RailsAdmin::Fields::#{it}".constantize
    end
  end
end