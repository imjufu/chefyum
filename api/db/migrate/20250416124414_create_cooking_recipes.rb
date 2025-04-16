class CreateCookingRecipes < ActiveRecord::Migration[8.0]
  def change
    create_table :cooking_recipes do |t|
      t.string :title
      t.text :description
      t.jsonb :steps

      t.timestamps
    end
  end
end
