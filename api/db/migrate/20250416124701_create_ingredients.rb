class CreateIngredients < ActiveRecord::Migration[8.0]
  def change
    create_table :ingredients, primary_key: [ :cooking_recipe_id, :food_id ] do |t|
      t.references :cooking_recipe
      t.references :food
      t.decimal :quantity, precision: 5, scale: 1

      t.timestamps
    end
  end
end
