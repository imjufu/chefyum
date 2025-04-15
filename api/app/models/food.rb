class Food < ApplicationRecord
  belongs_to :food_group, primary_key: "code", foreign_key: "food_group_code"
end
