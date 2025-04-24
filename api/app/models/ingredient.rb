class Ingredient < ApplicationRecord
  UNITS = {
    grams: "grams"
  }.freeze

  belongs_to :cooking_recipe
  belongs_to :food

  validates :quantity, numericality: true
  validates :cooking_recipe, :food, presence: true
  validates :unit, inclusion: { in: UNITS.keys.map(&:to_s) }
end
