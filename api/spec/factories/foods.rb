FactoryBot.define do
  factory :food do
    label { }
    source { "faker" }
    source_code { Faker::Barcode.ean }
    source_label { Faker::Food.ingredient }
    nutrition_facts do
      {
        energy: Faker::Number.between(from: 1.0, to: 200.0),
        proteins: Faker::Number.between(from: 1.0, to: 200.0),
        carbohydrates: Faker::Number.between(from: 1.0, to: 200.0),
        lipids: Faker::Number.between(from: 1.0, to: 200.0),
        sugars: Faker::Number.between(from: 1.0, to: 200.0),
        saturated_fatty_acids: Faker::Number.between(from: 1.0, to: 200.0),
        salt: Faker::Number.between(from: 1.0, to: 200.0),
        fibers: Faker::Number.between(from: 1.0, to: 200.0)
      }
    end
  end
end
