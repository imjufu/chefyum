class CookingRecipe < ApplicationRecord
  has_many :ingredients
  has_many :foods, through: :ingredients
  has_one_attached :photo

  validates :title, :description, :steps, :tags, :slug, presence: true
  validates :slug, uniqueness: true
  validates :servings, numericality: { only_integer: true }

  before_validation :set_slug, only: [ :create, :update ]

  def nutritional_values_per_serving
    return @nutritional_values if @nutritional_values

    @nutritional_values = Food::NUTRITIONAL_COMPOSITION.map { |nc| [ nc, 0 ] }.to_h
    ingredients.each do |ingredient|
      @nutritional_values.keys.each do |k|
        @nutritional_values[k] += (ingredient.food.nutrition_facts[k.to_s] || 0) * ingredient.quantity / 100
      end
    end
    @nutritional_values.each { |nv| @nutritional_values[nv[0]] = (nv[1] / servings).round(2) }

    @nutritional_values
  end

  def photo_url
    Rails.application.routes.url_helpers.rails_blob_url(photo) if photo.attached?
  end

  def as_json(options = nil, with_ingredients: false, with_nutritional_values: false)
    attrs = [ :id, :title, :slug, :servings, :description, :steps, :tags, :photo ]
    options ||= { methods: [ :photo_url ] }
    if with_ingredients
      relation = { ingredients: { only: [ :quantity, :unit ],  include: { food: { only: [ :id, :label ] } } } }
      if options.include? :include
        options[:include] += relation
      else
        options[:include] = relation
      end
    end
    if with_nutritional_values
      if options.include? :methods
        options[:methods] << :nutritional_values_per_serving
      else
        options[:methods] = [ :nutritional_values_per_serving ]
      end
    end
    super({ only: attrs }.merge(options || {}))
  end

  protected

  def set_slug
    self.slug ||= "#{title}-#{SecureRandom.urlsafe_base64}".parameterize unless title.blank?
  end
end
