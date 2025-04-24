require "rails_helper"

RSpec.describe CookingRecipe, type: :model do
  subject(:cooking_recipe) do
    FactoryBot.create(:cooking_recipe)
  end

  describe "#nutritional_values_per_serving" do
    it "returns a Hash" do
      expect(cooking_recipe.nutritional_values_per_serving).to be_a Hash
    end

    it "returns nutritional values" do
      expect(cooking_recipe.nutritional_values_per_serving).to match({
        "carbohydrates_in_g_per_100g" => an_instance_of(BigDecimal),
        "energy_in_kcal_per_100g" => an_instance_of(BigDecimal),
        "fibers_in_g_per_100g" => an_instance_of(BigDecimal),
        "lipids_in_g_per_100g" => an_instance_of(BigDecimal),
        "proteins_in_g_per_100g" => an_instance_of(BigDecimal),
        "salt_in_g_per_100g" => an_instance_of(BigDecimal),
        "saturated_fatty_acids_in_g_per_100g" => an_instance_of(BigDecimal),
        "sugars_in_g_per_100g" => an_instance_of(BigDecimal)
      })
    end
  end
end
