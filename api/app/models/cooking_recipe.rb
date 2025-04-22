class CookingRecipe < ApplicationRecord
  has_many :ingredients

  validates :title, :description, :steps, presence: true

  def nutritional_values
    return @nutritional_values if @nutritional_values

    @nutritional_values = {
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
      @nutritional_values.keys.each do |k|
        @nutritional_values[k] += ((ingredient.food.nutrition_facts[k.to_s] || 0) * ingredient.quantity / 100).round(2)
      end
    end
    @nutritional_values
  end

  def as_json(options = nil, with_ingredients: false, with_nutritional_values: false)
    attrs = [ :id, :title, :description, :steps ]
    options ||= {}
    if with_ingredients
      if options.include? :include
        options[:include] += :ingredients
      else
        options[:include] = :ingredients
      end
    end
    if with_nutritional_values
      if options.include? :methods
        options[:methods] += :nutritional_values
      else
        options[:methods] = :nutritional_values
      end
    end
    super({ only: attrs }.merge(options || {}))
  end
end
