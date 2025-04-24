FactoryBot.define do
  factory :food do
    label { }
    source { "faker" }
    source_code { Faker::Barcode.ean }
    source_label { Faker::Food.ingredient }
    nutrition_facts do
      {
        "energy_in_kcal_per_100g" => Faker::Number.between(from: 1.0, to: 200.0),
        "proteins_in_g_per_100g" => Faker::Number.between(from: 1.0, to: 200.0),
        "carbohydrates_in_g_per_100g" => Faker::Number.between(from: 1.0, to: 200.0),
        "lipids_in_g_per_100g" => Faker::Number.between(from: 1.0, to: 200.0),
        "sugars_in_g_per_100g" => Faker::Number.between(from: 1.0, to: 200.0),
        "saturated_fatty_acids_in_g_per_100g" => Faker::Number.between(from: 1.0, to: 200.0),
        "salt_in_g_per_100g" => Faker::Number.between(from: 1.0, to: 200.0),
        "fibers_in_g_per_100g" => Faker::Number.between(from: 1.0, to: 200.0)
      }
    end
  end
end
