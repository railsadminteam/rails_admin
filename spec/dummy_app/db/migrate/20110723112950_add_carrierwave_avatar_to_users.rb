class AddCarrierwaveAvatarToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :cw_avatar_image, :string
  end

  def self.down
    remove_column :users, :cw_avatar_image
  end
end
