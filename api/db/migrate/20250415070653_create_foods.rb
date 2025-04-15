class CreateFoods < ActiveRecord::Migration[7.2]
  def change
    create_table :foods, id: :string, primary_key: 'code' do |t|
      t.string :label
      t.jsonb :nutrition_facts
      t.string :food_group_code

      t.timestamps
    end
    add_foreign_key :foods, :food_groups, column: :food_group_code, primary_key: :code
  end
end
