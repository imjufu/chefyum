FactoryBot.define do
  factory :cooking_recipe do
    title { Faker::Food.dish }
    description { Faker::Food.description }
    servings { 1 }
    steps do
      [
        { step: 1, instruction: Faker::Lorem.sentence },
        { step: 2, instruction: Faker::Lorem.sentence },
        { step: 3, instruction: Faker::Lorem.sentence }
      ]
    end
    tags { Faker::Lorem.words }

    transient do
      ingredients_count { 5 }
    end

    ingredients do
      Array.new(ingredients_count) { association(:ingredient, cooking_recipe: instance) }
    end
  end
end
