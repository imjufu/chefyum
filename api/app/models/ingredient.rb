class Ingredient < ApplicationRecord
  belongs_to :cooking_recipe
  belongs_to :food

  validates :quantity, numericality: true
  validates :cooking_recipe, :food, presence: true
end
