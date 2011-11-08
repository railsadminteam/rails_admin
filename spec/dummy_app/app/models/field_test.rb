class FieldTest < ActiveRecord::Base
  has_one :comment, :as => :commentable
  attr_accessible :dragonfly_asset, :remove_dragonfly_asset, :retained_dragonfly_asset, :carrierwave_asset, :carrierwave_asset_cache, :remove_carrierwave_asset, :paperclip_asset, :delete_paperclip_asset, :comment_id, :string_field, :text_field, :integer_field, :float_field, :decimal_field, :datetime_field, :timestamp_field, :time_field, :date_field, :boolean_field, :created_at, :updated_at, :format
  attr_accessible :dragonfly_asset, :remove_dragonfly_asset, :retained_dragonfly_asset, :carrierwave_asset, :carrierwave_asset_cache, :remove_carrierwave_asset, :paperclip_asset, :delete_paperclip_asset, :comment_id, :string_field, :text_field, :integer_field, :float_field, :decimal_field, :datetime_field, :timestamp_field, :time_field, :date_field, :boolean_field, :created_at, :updated_at, :format, :restricted_field, :as => :custom_role
  attr_accessible :dragonfly_asset, :remove_dragonfly_asset, :retained_dragonfly_asset, :carrierwave_asset, :carrierwave_asset_cache, :remove_carrierwave_asset, :paperclip_asset, :delete_paperclip_asset, :comment_id, :string_field, :text_field, :integer_field, :float_field, :decimal_field, :datetime_field, :timestamp_field, :time_field, :date_field, :boolean_field, :created_at, :updated_at, :format, :protected_field, :as => :extra_safe_role
  
  has_attached_file :paperclip_asset, :styles => { :thumb => "100x100>" }
  attr_accessor :delete_paperclip_asset
  before_validation { self.paperclip_asset = nil if self.delete_paperclip_asset == '1' }

  image_accessor :dragonfly_asset
  mount_uploader :carrierwave_asset, CarrierwaveUploader
end
