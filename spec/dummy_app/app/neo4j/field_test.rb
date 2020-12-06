class FieldTest
  include Neo4j::ActiveNode

  #include Mongoid::Paperclip
  include ActiveModel::ForbiddenAttributesProtection
  extend Dragonfly::Model

  property :name, type: String
  property :title, type: String
  property :subject, type: String
  property :short_text, type: String

  property :array_field, type: Array
  property :big_decimal_field, type: BigDecimal
  property :boolean_field, type: Boolean
  property :bson_object_id_field, type: RailsAdmin::Adapters::Mongoid::ObjectId
  property :bson_binary_field, type: BSON::Binary
  property :date_field, type: Date
  property :datetime_field, type: DateTime
  property :time_with_zone_field, type: ActiveSupport::TimeWithZone
  property :default_field
  property :float_field, type: Float
  property :hash_field, type: Hash
  property :integer_field, type: Integer
  property :object_field, type: Object
  property :range_field, type: Range
  property :string_field, type: String
  property :symbol_field, type: Symbol
  property :text_field, type: String
  property :time_field, type: Time

  property :format, type: String
  property :restricted_field, type: String
  property :protected_field, type: String
  has_mongoid_attached_file :paperclip_asset, styles: {thumb: '100x100>'}

  has_many :in, :nested_field_tests, dependent: :destroy, origin: :field_test#, autosave: true
  #accepts_nested_attributes_for :nested_field_tests, allow_destroy: true

  # on creation, comment is not saved without autosave: true
  has_one :comment, as: :commentable, autosave: true
  #accepts_nested_attributes_for :comment, allow_destroy: true

  embeds_many :embeds
  #accepts_nested_attributes_for :embeds, allow_destroy: true

  attr_accessor :delete_paperclip_asset
  before_validation { self.paperclip_asset = nil if delete_paperclip_asset == '1' }

  property :dragonfly_asset_name
  property :dragonfly_asset_uid
  dragonfly_accessor :dragonfly_asset
  mount_uploader :carrierwave_asset, CarrierwaveUploader

  validates :short_text, length: {maximum: 255}
end
