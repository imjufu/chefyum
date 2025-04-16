class CreateIngredients < ActiveRecord::Migration[8.0]
  def change
    create_table :ingredients, primary_key: [ :cooking_recipe_id, :food_code ] do |t|
      t.integer :cooking_recipe_id, null: false
      t.string :food_code, null: false
      t.decimal :quantity, precision: 5, scale: 1

      t.timestamps
    end
    add_foreign_key :ingredients, :cooking_recipes, column: :cooking_recipe_id, primary_key: :id
    add_foreign_key :ingredients, :foods, column: :food_code, primary_key: :code
  end
end
