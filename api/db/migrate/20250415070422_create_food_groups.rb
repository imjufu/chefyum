class CreateFoodGroups < ActiveRecord::Migration[7.2]
  def change
    create_table :food_groups, id: :string, primary_key: 'code' do |t|
      t.string :label

      t.timestamps
    end
  end
end
