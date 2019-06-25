class ManagingUser < User
  has_many :teams, class_name: 'ManagedTeam', foreign_key: :manager, primary_key: :email, inverse_of: :user
end
