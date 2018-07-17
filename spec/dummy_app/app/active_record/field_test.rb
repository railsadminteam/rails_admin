class FieldTest < ActiveRecord::Base
  has_many :nested_field_tests, dependent: :destroy, inverse_of: :field_test
  accepts_nested_attributes_for :nested_field_tests, allow_destroy: true

  has_one :comment, as: :commentable
  accepts_nested_attributes_for :comment, allow_destroy: true

  has_attached_file :paperclip_asset, styles: {thumb: '100x100>'}
  attr_accessor :delete_paperclip_asset
  before_validation { self.paperclip_asset = nil if delete_paperclip_asset == '1' }

  dragonfly_accessor :dragonfly_asset

  mount_uploader :carrierwave_asset, CarrierwaveUploader
  mount_uploaders :carrierwave_assets, CarrierwaveUploader
  serialize :carrierwave_assets, JSON
  attr_accessor :delete_carrierwave_assets
  after_validation do
    uploaders = carrierwave_assets.delete_if do |uploader|
      if Array(delete_carrierwave_assets).include?(uploader.file.identifier)
        uploader.remove!
        true
      end
    end
    write_attribute(:carrierwave_assets, uploaders.map { |uploader| uploader.file.identifier })
  end
  def carrierwave_assets=(files)
    appended = files.map do |file|
      uploader = _mounter(:carrierwave_assets).blank_uploader
      uploader.cache! file
      uploader
    end
    super(carrierwave_assets + appended)
  end

  attachment :refile_asset if defined?(Refile)

  if defined?(ActiveStorage)
    has_one_attached :active_storage_asset
    attr_accessor :remove_active_storage_asset
    after_save { active_storage_asset.purge if remove_active_storage_asset == '1' }

    has_many_attached :active_storage_assets
    attr_accessor :remove_active_storage_assets
    after_save do
      Array(remove_active_storage_assets).each { |id| active_storage_assets.find_by_id(id).try(:purge) }
    end
  end

  if ::Rails.version >= '4.1' # enum support was added in Rails 4.1
    enum string_enum_field: {S: 's', M: 'm', L: 'l'}
    enum integer_enum_field: [:small, :medium, :large]
  end
end
