class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable

  serialize :roles, Array

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :roles, :avatar


  # Add Paperclip support for avatars
  has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100>" }

  attr_accessor :delete_avatar
  before_validation { self.avatar = nil if self.delete_avatar == '1' }

  def attr_accessible_role
    :custom_role
  end

  def roles_enum
    [:admin, :user]
  end
end
