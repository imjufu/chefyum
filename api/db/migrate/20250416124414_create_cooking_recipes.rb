class CreateCookingRecipes < ActiveRecord::Migration[8.0]
  def change
    create_table :cooking_recipes do |t|
      t.string :title, null: false
      t.string :slug, null: false
      t.text :description
      t.integer :servings, null: false
      t.jsonb :steps, null: false
      t.jsonb :tags, null: false

      t.timestamps
    end
    add_index :cooking_recipes, :slug, unique: true
  end
end
