require "rails_helper"

RSpec.describe Food, type: :model do
  subject(:food) { FactoryBot.build(:food) }

  describe "#nutrition_facts_format" do
    it "does not add errors" do
      expect { food.valid? }.not_to change { food.errors.count }
    end

    context "when the nutrition_facts format is invalid" do
      before { food.nutrition_facts = { a: 123 } }

      it "adds an error" do
        expect { food.valid? }.to change { food.errors.count }.from(0).to(1)
      end

      it "returns a error" do
        expect { food.valid? }.to change { food.errors.full_messages }.from([]).to([
          "Nutrition facts must have all the following keys: energy, proteins, carbohydrates, lipids, sugars, saturated_fatty_acids, salt, fibers"
        ])
      end
    end
  end
end
