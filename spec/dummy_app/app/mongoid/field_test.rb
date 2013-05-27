class FieldTest
  include Mongoid::Document
  include Mongoid::Paperclip
  include ActiveModel::ForbiddenAttributesProtection

  field :name, :type => String
  field :title, :type => String
  field :subject, :type => String
  field :short_text, :type => String

  field :array_field, :type => Array
  field :big_decimal_field, :type => BigDecimal
  field :boolean_field, :type => Boolean
  field :bson_object_id_field, :type => RailsAdmin::Adapters::Mongoid::ObjectId
  field :bson_binary_field, :type => Moped::BSON::Binary
  field :date_field, :type => Date
  field :datetime_field, :type => DateTime
  field :time_with_zone_field, :type => ActiveSupport::TimeWithZone
  field :default_field
  field :float_field, :type => Float
  field :hash_field, :type => Hash
  field :integer_field, :type => Integer
  field :object_field, :type => Object
  field :range_field, :type => Range
  field :string_field, :type => String
  field :symbol_field, :type => Symbol
  field :text_field, :type => String
  field :time_field, :type => Time

  field :format, :type => String
  field :restricted_field, :type => String
  field :protected_field, :type => String
  has_mongoid_attached_file :paperclip_asset, :styles => { :thumb => "100x100>" }

  has_many :nested_field_tests, :dependent => :destroy, :inverse_of => :field_test, :autosave => true
  accepts_nested_attributes_for :nested_field_tests, :allow_destroy => true

  # on creation, comment is not saved without :autosave => true
  has_one :comment, :as => :commentable, :autosave => true
  accepts_nested_attributes_for :comment, :allow_destroy => true

  embeds_many :embeds
  accepts_nested_attributes_for :embeds, :allow_destroy => true

  attr_accessor :delete_paperclip_asset
  before_validation { self.paperclip_asset = nil if self.delete_paperclip_asset == '1' }

  field :dragonfly_asset_name
  field :dragonfly_asset_uid
  image_accessor :dragonfly_asset
  mount_uploader :carrierwave_asset, CarrierwaveUploader

  validates :short_text, :length => {:maximum => 255}
end
