

if defined?(CompositePrimaryKeys)
  class Fanship < ActiveRecord::Base
    self.table_name = :fans_teams
    self.primary_keys = :fan_id, :team_id
    belongs_to :fan, inverse_of: :fanships, optional: true
    belongs_to :team, optional: true
    has_many :favorite_players, foreign_key: %i[fan_id team_id], inverse_of: :fanship
  end
else
  class Fanship; end
end
