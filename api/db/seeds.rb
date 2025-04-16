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

  cooking_recipe = CookingRecipe.find_or_create_by(title: 'Pâtes au poulet')
  cooking_recipe.update(
    description: 'Simple, rapide, efficace !',
    steps: [
      { step: 1, instruction: 'Faites cuire les pâtes' },
      { step: 2, instruction: 'Faites cuire le poulet' },
      { step: 3, instruction: 'Mettez les pâtes et le poulet dans une assiette. Salez et poivrez' },
      { step: 4, instruction: "Ajoutez un filet d'huile d'olive. Salez et poivrez." }
    ]
  )
  Ingredient.find_or_create_by(cooking_recipe_id: cooking_recipe.id, food_code: '36017', quantity: 100)
  Ingredient.find_or_create_by(cooking_recipe_id: cooking_recipe.id, food_code: '9870', quantity: 80)
end
