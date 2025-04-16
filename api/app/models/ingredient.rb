class Ingredient < ApplicationRecord
  belongs_to :cooking_recipe
  belongs_to :food, primary_key: "code", foreign_key: "food_code"
end
