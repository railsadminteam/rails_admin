

class ManagedTeam < Team
  belongs_to :user, class_name: 'ManagingUser', foreign_key: :manager, primary_key: :email, optional: true, inverse_of: :teams
end
