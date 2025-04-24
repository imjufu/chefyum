require "rails_helper"

RSpec.describe Ciqual::XmlParser do
  let(:subject) { Ciqual::XmlParser.new(Rails.root.join("spec/fixtures/lite_ciqual_data")) }

  describe "#parse!" do
    it "returns true" do
      expect(subject.parse!).to be true
    end

    it "parses foods" do
      expect { subject.parse! }.to change { subject.foods.length }.from(0).to(3185)
    end

    it "sets foods" do
      subject.parse!
      expect(subject.foods.first).to eq([
        "1000",
        {
          source: "ciqual.anses",
          source_code: "1000",
          source_label: "Pastis",
          nutrition_facts: {
            "energy_in_kcal_per_100g" => 274.0,
            "salt_in_g_per_100g" => 0.0,
            "proteins_in_g_per_100g" => 0.0,
            "carbohydrates_in_g_per_100g" => 2.86,
            "sugars_in_g_per_100g" => 0.0,
            "fibers_in_g_per_100g" => 0.0,
            "lipids_in_g_per_100g" => 0.0,
            "saturated_fatty_acids_in_g_per_100g" => 0.0
          }
        }
      ])
    end
  end
end
