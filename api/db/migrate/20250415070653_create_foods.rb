class CreateFoods < ActiveRecord::Migration[7.2]
  def change
    create_table :foods do |t|
      t.string :label
      t.jsonb :nutrition_facts, null: false
      t.string :source
      t.string :source_code
      t.string :source_label

      t.timestamps
    end
    add_index :foods, [ :source, :source_code ], unique: true
  end
end
