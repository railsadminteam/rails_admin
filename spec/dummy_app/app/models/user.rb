class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me

  # Add Paperclip support for avatars
  has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100>" }

  # Also add Carrierwave support
  mount_uploader :cw_avatar_image, AvatarUploader
  
  serialize :roles, Array
end
