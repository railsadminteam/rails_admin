

class ManagingUser < User
  has_one :team, class_name: 'ManagedTeam', foreign_key: :manager, primary_key: :email, inverse_of: :user
  has_many :teams, class_name: 'ManagedTeam', foreign_key: :manager, primary_key: :email, inverse_of: :user
  has_and_belongs_to_many :players, foreign_key: :player_names, primary_key: :name, inverse_of: :nil
  has_and_belongs_to_many :balls, primary_key: :color, inverse_of: :nil
end
