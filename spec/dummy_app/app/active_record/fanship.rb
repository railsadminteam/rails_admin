# frozen_string_literal: true

if ActiveRecord.gem_version >= Gem::Version.new('7.1') || defined?(CompositePrimaryKeys)
  class Fanship < ActiveRecord::Base
    self.table_name = :fans_teams
    if defined?(CompositePrimaryKeys)
      self.primary_keys = :fan_id, :team_id
    else
      self.primary_key = :fan_id, :team_id
    end
    if defined?(CompositePrimaryKeys) || ActiveRecord.gem_version >= Gem::Version.new('7.2')
      has_many :favorite_players, foreign_key: %i[fan_id team_id], inverse_of: :fanship
    else
      has_many :favorite_players, query_constraints: %i[fan_id team_id], inverse_of: :fanship
    end

    belongs_to :fan, inverse_of: :fanships, optional: true
    belongs_to :team, optional: true
  end
else
  class Fanship; end
end
