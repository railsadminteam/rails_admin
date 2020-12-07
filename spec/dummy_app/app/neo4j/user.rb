class User
  include Neo4j::ActiveNode
  #include Mongoid::Paperclip
  include ActiveModel::ForbiddenAttributesProtection
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable

  ## Database authenticatable
  property :email,              type: String
  property :encrypted_password, type: String

  ## Recoverable
  property :reset_password_token,   type: String
  property :reset_password_sent_at, type: Time

  ## Rememberable
  property :remember_created_at, type: Time

  ## Trackable
  property :sign_in_count,      type: Integer
  property :current_sign_in_at, type: Time
  property :last_sign_in_at,    type: Time
  property :current_sign_in_ip, type: String
  property :last_sign_in_ip,    type: String

  ## Encryptable
  # property :password_salt, type: String

  ## Confirmable
  # property :confirmation_token,   type: String
  # property :confirmed_at,         type: Time
  # property :confirmation_sent_at, type: Time
  # property :unconfirmed_email,    type: String # Only if using reconfirmable

  ## Lockable
  # property :failed_attempts, type: Integer # Only if lock strategy is :failed_attempts
  # property :unlock_token,    type: String # Only if unlock strategy is :email or :both
  # property :locked_at,       type: Time

  # Token authenticatable
  # property :authentication_token, type: String

  ## Invitable
  # property :invitation_token, type: String

  property :created_at, type: DateTime
  property :updated_at, type: DateTime

  # Add Paperclip support for avatars
  #has_mongoid_attached_file :avatar, styles: {medium: '300x300>', thumb: '100x100>'}

  property :roles
  serialize :roles

  def attr_accessible_role
    :custom_role
  end

  attr_accessor :delete_avatar
  before_validation { self.avatar = nil if delete_avatar == '1' }
end
