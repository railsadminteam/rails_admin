class AddTextToPlayer < ActiveRecord::Migration
  def up
    Player.create_translation_table! :text => :text
  end
  def down
    Player.drop_translation_table!
  end
end
