

if defined?(CompositePrimaryKeys)
  class FavoritePlayer < ActiveRecord::Base
    self.primary_keys = :fan_id, :team_id, :player_id
    belongs_to :fanship, foreign_key: %i[fan_id team_id], inverse_of: :favorite_players
    belongs_to :player
  end
end
