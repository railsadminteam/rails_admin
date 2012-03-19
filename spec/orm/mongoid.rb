class Tableless
  include Mongoid::Document

  class <<self
    def column(name, sql_type = nil, default = nil, null = true)
      field name, :type => {
        :integer => Integer,
        :string => String,
        :text => Text,
        :date => Date,
      }
    end
  end
end
