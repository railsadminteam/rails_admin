class User
  include Mongoid::Document
  include Mongoid::Paperclip
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable

  include Mongoid::Timestamps

  # Add Paperclip support for avatars
  has_mongoid_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100>" }

  field :roles, :type => Array

  def attr_accessible_role
    :custom_role
  end

  attr_accessor :delete_avatar
  before_validation { self.avatar = nil if self.delete_avatar == '1' }
end
