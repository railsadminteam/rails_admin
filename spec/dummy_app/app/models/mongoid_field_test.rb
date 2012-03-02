class MongoidFieldTest
  include Mongoid::Document

  field :name, :type => String
  field :title, :type => String
  field :subject, :type => String
  field :description, :type => String
  field :short_text, :type => String
  field :array_field, :type => Array
  field :big_decimal_field, :type => BigDecimal
  field :boolean_field, :type => Boolean
  field :bson_object_id_field, :type => BSON::ObjectId
  field :date_field, :type => Date
  field :date_time_field, :type => DateTime
  field :float_field, :type => Float
  field :hash_field, :type => Hash
  field :integer_field, :type => Integer
  field :time_field, :type => Time
  field :object_field, :type => Object

  validates :short_text, :length => {:maximum => 255}
end
