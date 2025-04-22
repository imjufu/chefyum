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
            salt: 0.0,
            energy: 274.0,
            fibers: 0.0,
            lipids: 0.0,
            sugars: 0.0,
            proteins: 0.0,
            carbohydrates: 2.86,
            saturated_fatty_acids: 0.0
          }
        }
      ])
    end
  end
end
