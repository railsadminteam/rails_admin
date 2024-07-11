

class CreateTwoLevelNamespacedPolymorphicAssociationTests < ActiveRecord::Migration[5.0]
  def change
    create_table :two_level_namespaced_polymorphic_association_tests do |t|
      t.string :name

      t.timestamps
    end
  end
end
