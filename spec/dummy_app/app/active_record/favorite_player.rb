# frozen_string_literal: true

if ActiveRecord.gem_version >= Gem::Version.new('7.1') || defined?(CompositePrimaryKeys)
  class FavoritePlayer < ActiveRecord::Base
    if defined?(CompositePrimaryKeys)
      self.primary_keys = :fan_id, :team_id, :player_id
      belongs_to :fanship, foreign_key: %i[fan_id team_id], inverse_of: :favorite_players
    else
      self.primary_key = :fan_id, :team_id, :player_id
      belongs_to :fanship, query_constraints: %i[fan_id team_id], inverse_of: :favorite_players
    end

    belongs_to :player
  end
end
