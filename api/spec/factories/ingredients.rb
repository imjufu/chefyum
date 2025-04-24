FactoryBot.define do
  factory :ingredient do
    cooking_recipe
    food
    quantity { Faker::Number.between(from: 50, to: 150) }
    unit { Ingredient::UNITS[:grams] }
  end
end
