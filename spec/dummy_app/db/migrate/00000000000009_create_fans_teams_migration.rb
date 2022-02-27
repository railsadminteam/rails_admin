# frozen_string_literal: true

class CreateFansTeamsMigration < ActiveRecord::Migration[5.0]
  def self.up
    create_table :fans_teams, id: false do |t|
      t.integer :fan_id, :team_id
    end
  end

  def self.down
    drop_table :fans_teams
  end
end
