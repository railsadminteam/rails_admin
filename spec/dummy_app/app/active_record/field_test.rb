class FieldTest < ActiveRecord::Base
  basic_accessible_fields = [:comment_attributes, :nested_field_tests_attributes, :dragonfly_asset, :remove_dragonfly_asset, :retained_dragonfly_asset, :carrierwave_asset, :carrierwave_asset_cache, :remove_carrierwave_asset, :paperclip_asset, :delete_paperclip_asset, :comment_id, :string_field, :text_field, :integer_field, :float_field, :decimal_field, :datetime_field, :timestamp_field, :time_field, :date_field, :boolean_field, :created_at, :updated_at, :format]
  attr_accessible *basic_accessible_fields
  attr_accessible *(basic_accessible_fields + [:restricted_field, {:as => :custom_role}])
  attr_accessible *(basic_accessible_fields + [:protected_field, {:as => :extra_safe_role}])

  has_many :nested_field_tests, :dependent => :destroy, :inverse_of => :field_test
  accepts_nested_attributes_for :nested_field_tests, :allow_destroy => true

  has_one :comment, :as => :commentable
  accepts_nested_attributes_for :comment, :allow_destroy => true

  has_attached_file :paperclip_asset, :styles => { :thumb => "100x100>" }
  attr_accessor :delete_paperclip_asset
  before_validation { self.paperclip_asset = nil if self.delete_paperclip_asset == '1' }

  image_accessor :dragonfly_asset
  mount_uploader :carrierwave_asset, CarrierwaveUploader
end
