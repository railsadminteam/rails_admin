# frozen_string_literal: true

class CreateDraftsMigration < ActiveRecord::Migration[5.0]
  def self.up
    create_table :drafts do |t|
      t.timestamps null: false
      t.integer :player_id
      t.integer :team_id
      t.date :date
      t.integer :round
      t.integer :pick
      t.integer :overall
      t.string :college, limit: 100
      t.text :notes
    end
  end

  def self.down
    drop_table :drafts
  end
end
