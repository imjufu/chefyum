class AddProfileToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :profile, :string, null: false, default: User::PROFILES[:basic]
  end
end
