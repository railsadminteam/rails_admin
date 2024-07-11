

class CreatePaperTrailTests < ActiveRecord::Migration[5.0]
  def change
    create_table :paper_trail_tests do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
