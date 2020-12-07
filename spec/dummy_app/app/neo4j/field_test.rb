class FieldTest
  include Neo4j::ActiveNode

  include Neo4jrb::Paperclip
  include ActiveModel::ForbiddenAttributesProtection
  extend Dragonfly::Model

  property :name, type: String
  property :title, type: String
  property :subject, type: String
  property :short_text, type: String

  property :big_decimal_field, type: BigDecimal
  property :boolean_field, type: Boolean
  property :date_field, type: Date
  property :datetime_field, type: DateTime
  property :default_field
  property :float_field, type: Float
  property :hash_field, type: Hash
  property :integer_field, type: Integer
  property :object_field, type: Object
  property :string_field, type: String
  property :text_field, type: String
  property :time_field, type: Time

  property :format, type: String
  property :restricted_field, type: String
  property :protected_field, type: String
  has_neo4jrb_attached_file :paperclip_asset, styles: {thumb: '100x100>'}

  has_many :in, :nested_field_tests, dependent: :destroy, origin: :field_test#, autosave: true
  #accepts_nested_attributes_for :nested_field_tests, allow_destroy: true

  # on creation, comment is not saved without autosave: true
  #has_one :in,:comment, as: :commentable, autosave: true
  #accepts_nested_attributes_for :comment, allow_destroy: true

  attr_accessor :delete_paperclip_asset
  before_validation { self.paperclip_asset = nil if delete_paperclip_asset == '1' }

  property :dragonfly_asset_name
  property :dragonfly_asset_uid
  dragonfly_accessor :dragonfly_asset
  property :carrierwave_asset, type: String
  mount_uploader :carrierwave_asset, CarrierwaveUploader

  validates :short_text, length: {maximum: 255}
end
