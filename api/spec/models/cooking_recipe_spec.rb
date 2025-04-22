require "rails_helper"

RSpec.describe CookingRecipe, type: :model do
  subject(:cooking_recipe) do
    FactoryBot.create(:cooking_recipe)
  end

  describe "#nutritional_values" do
    it "returns a Hash" do
      expect(cooking_recipe.nutritional_values).to be_a Hash
    end

    it "returns nutritional values" do
      expect(cooking_recipe.nutritional_values).to match({
        carbohydrates: an_instance_of(BigDecimal),
        energy: an_instance_of(BigDecimal),
        fibers: an_instance_of(BigDecimal),
        lipids: an_instance_of(BigDecimal),
        proteins: an_instance_of(BigDecimal),
        salt: an_instance_of(BigDecimal),
        saturated_fatty_acids: an_instance_of(BigDecimal),
        sugars: an_instance_of(BigDecimal)
      })
    end
  end
end
