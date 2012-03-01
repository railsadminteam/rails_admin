class CreateUnscopedPages < ActiveRecord::Migration
  def change
    create_table :unscoped_pages do |t|
      t.string :title

      t.timestamps
    end
  end
end
