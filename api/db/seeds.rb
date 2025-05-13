# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

if Rails.env.development?
  user = User.find_or_create_by(email: 'julien@chefyum.fr')
  user.update(
    name: 'Julien',
    password: 'password',
    gender: "male",
    birthdate: '1984-11-24',
    height_in_centimeters: 180,
    weight_in_grams: 80,
    activity_level: 'active',
  )
  user.confirm!

  UpdateCiqualDataJob.perform_now if Food.count == 0

  cooking_recipe_1 = CookingRecipe.find_or_create_by(title: 'Pâtes au poulet')
  cooking_recipe_1.update(
    description: 'Simple, rapide, efficace !',
    servings: 1,
    steps: [
      { step: 1, instruction: 'Faites cuire les pâtes' },
      { step: 2, instruction: 'Faites cuire le poulet' },
      { step: 3, instruction: 'Mettez les pâtes et le poulet dans une assiette' },
      { step: 4, instruction: "Ajoutez un filet d'huile d'olive. Salez et poivrez" }
    ],
    tags: [ 'Protéinée', 'Rapide et facile' ]
  )
  cooking_recipe_1.photo.attach(
    io: File.open(Rails.root.join("spec/fixtures/images/pates-poulet.jpg")),
    filename: 'pates-poulet.jpg',
    content_type: "image/jpeg",
  )

  chicken = Food.find_by(source: Ciqual::XmlParser::SOURCE, source_code: '36017')
  pasta = Food.find_by(source: Ciqual::XmlParser::SOURCE, source_code: '9870')
  Ingredient.find_or_create_by(cooking_recipe_id: cooking_recipe_1.id, food_id: chicken.id, quantity: 100, unit: Ingredient::UNITS[:grams])
  Ingredient.find_or_create_by(cooking_recipe_id: cooking_recipe_1.id, food_id: pasta.id, quantity: 80, unit: Ingredient::UNITS[:grams])

  cooking_recipe_2 = CookingRecipe.find_or_create_by(title: 'Riz dinde')
  cooking_recipe_2.update(
    description: 'Un classique !',
    servings: 1,
    steps: [
      { step: 1, instruction: 'Faites cuire le riz' },
      { step: 2, instruction: 'Faites cuire la dinde' },
      { step: 3, instruction: 'Mettez le riz et la dinde dans une assiette' },
      { step: 4, instruction: "Ajoutez un filet d'huile d'olive. Salez et poivrez" }
    ],
    tags: [ 'Protéinée', 'Rapide et facile' ]
  )
  cooking_recipe_2.photo.attach(
    io: File.open(Rails.root.join("spec/fixtures/images/riz-dinde.jpg")),
    filename: 'riz-dinde.jpg',
    content_type: "image/jpeg",
  )

  rice = Food.find_by(source: Ciqual::XmlParser::SOURCE, source_code: '9100')
  turkey = Food.find_by(source: Ciqual::XmlParser::SOURCE, source_code: '36301')
  Ingredient.find_or_create_by(cooking_recipe_id: cooking_recipe_2.id, food_id: turkey.id, quantity: 100, unit: Ingredient::UNITS[:grams])
  Ingredient.find_or_create_by(cooking_recipe_id: cooking_recipe_2.id, food_id: rice.id, quantity: 80, unit: Ingredient::UNITS[:grams])

  cooking_recipe_3 = CookingRecipe.find_or_create_by(title: 'Salade italienne')
  cooking_recipe_3.update(
    description: 'Sain et gourmand !',
    servings: 1,
    steps: [
      { step: 1, instruction: 'Lavez la salade' },
      { step: 2, instruction: 'Coupez les tomates et le poulet' },
      { step: 3, instruction: 'Disposez la salde dans une assiette avec le poulet, les tomates et le parmesan' },
      { step: 4, instruction: "Ajoutez un filet d'huile d'olive. Salez et poivrez" }
    ],
    tags: [ 'Protéinée' ]
  )
  cooking_recipe_3.photo.attach(
    io: File.open(Rails.root.join("spec/fixtures/images/salade.jpg")),
    filename: 'salade.jpg',
    content_type: "image/jpeg",
  )

  salad = Food.find_by(source: Ciqual::XmlParser::SOURCE, source_code: '25604')
  chicken = Food.find_by(source: Ciqual::XmlParser::SOURCE, source_code: '28963')
  parmesan = Food.find_by(source: Ciqual::XmlParser::SOURCE, source_code: '12120')
  Ingredient.find_or_create_by(cooking_recipe_id: cooking_recipe_3.id, food_id: chicken.id, quantity: 100, unit: Ingredient::UNITS[:grams])
  Ingredient.find_or_create_by(cooking_recipe_id: cooking_recipe_3.id, food_id: salad.id, quantity: 150, unit: Ingredient::UNITS[:grams])
  Ingredient.find_or_create_by(cooking_recipe_id: cooking_recipe_3.id, food_id: parmesan.id, quantity: 50, unit: Ingredient::UNITS[:grams])

  cooking_recipe_4 = CookingRecipe.find_or_create_by(title: 'Pancakes')
  cooking_recipe_4.update(
    description: "Pour un petit déjeuner plein d'énergie !",
    servings: 1,
    steps: [
      { step: 1, instruction: 'Mélangez tous les ingrédients dans un bol' },
      { step: 2, instruction: 'Mixez' },
      { step: 3, instruction: 'Versez une louche dans une poêle chaude' },
      { step: 4, instruction: "Faites cuire 3 minutes par face" }
    ],
    tags: [ 'Protéinée', 'Sucrée' ]
  )
  cooking_recipe_4.photo.attach(
    io: File.open(Rails.root.join("spec/fixtures/images/pancakes.jpg")),
    filename: 'pancakes.jpg',
    content_type: "image/jpeg",
  )

  oats = Food.find_by(source: Ciqual::XmlParser::SOURCE, source_code: '9310')
  egg = Food.find_by(source: Ciqual::XmlParser::SOURCE, source_code: '22000')
  banana = Food.find_by(source: Ciqual::XmlParser::SOURCE, source_code: '13005')
  milk = Food.find_by(source: Ciqual::XmlParser::SOURCE, source_code: '19042')
  Ingredient.find_or_create_by(cooking_recipe_id: cooking_recipe_4.id, food_id: oats.id, quantity: 50, unit: Ingredient::UNITS[:grams])
  Ingredient.find_or_create_by(cooking_recipe_id: cooking_recipe_4.id, food_id: egg.id, quantity: 50, unit: Ingredient::UNITS[:grams])
  Ingredient.find_or_create_by(cooking_recipe_id: cooking_recipe_4.id, food_id: banana.id, quantity: 80, unit: Ingredient::UNITS[:grams])
  Ingredient.find_or_create_by(cooking_recipe_id: cooking_recipe_4.id, food_id: milk.id, quantity: 100, unit: Ingredient::UNITS[:grams])
end
