class Ingredient < ApplicationRecord
  belongs_to :cooking_recipe
  belongs_to :food
end
