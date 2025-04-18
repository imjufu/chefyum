class CookingRecipe < ApplicationRecord
  has_many :ingredients

  validates :title, :description, :steps, presence: true

  def calculate_nutritional_values
    nutritional_values = {
      energy: 0,
      proteins: 0,
      carbohydrates: 0,
      lipids: 0,
      sugars: 0,
      saturated_fatty_acids: 0,
      salt: 0,
      fibers: 0
    }
    ingredients.each do |ingredient|
      nutritional_values.keys.each do |k|
        nutritional_values[k] += ((ingredient.food.nutrition_facts[k.to_s] || 0) * ingredient.quantity / 100).round(2)
      end
    end
    nutritional_values
  end
end
