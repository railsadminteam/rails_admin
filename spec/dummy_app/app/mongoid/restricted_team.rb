

class RestrictedTeam < Team
  has_many :players, foreign_key: :team_id, dependent: :restrict_with_error
end
