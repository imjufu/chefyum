class CookingRecipe < ApplicationRecord
  has_many :ingredients
  has_many :foods, through: :ingredients

  validates :title, :description, :steps, :slug, presence: true
  validates :slug, uniqueness: true

  before_validation :set_slug, only: [ :create, :update ]

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
    attrs = [ :id, :title, :slug, :description, :steps ]
    options ||= {}
    if with_ingredients
      relation = { ingredients: { only: [ :quantity ],  include: { food: { only: [ :id, :label ] } } } }
      if options.include? :include
        options[:include] += relation
      else
        options[:include] = relation
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

  protected

  def set_slug
    self.slug ||= "#{title}-#{SecureRandom.urlsafe_base64}".parameterize unless title.blank?
  end
end
