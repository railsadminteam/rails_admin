class Tableless
  include Mongoid::Document

  class <<self
    def column(name, sql_type = nil, default = nil, null = true)
      field name, :type => {
        :integer => Integer,
        :string => String,
        :text => String,
        :date => Date,
      }[sql_type]
    end
  end
end
