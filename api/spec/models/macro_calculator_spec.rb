# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MacroCalculator do
  subject(:macro_calc) do
    described_class.new({
                          gender: 'male',
                          birthdate: 39.years.ago,
                          height_in_centimeters: 180,
                          weight_in_kilograms: 80,
                          activity_level: 'moderately_active'
                        })
  end

  describe '#calculate' do
    it 'returns a Hash' do
      expect(macro_calc.calculate).to be_a Hash
    end

    it 'returns the tdee, the bmr and the macronutrients in grams' do
      expect(macro_calc.calculate).to eq({
                                           tdee: 2689,
                                           bmr: 1735,
                                           carbohydrate_in_grams: 326,
                                           lipid_in_grams: 89,
                                           protein_in_grams: 144
                                         })
    end

    context 'when the object is invalid' do
      before { macro_calc.gender = 'unknown' }

      it 'returns false' do
        expect(macro_calc.calculate).to be false
      end
    end
  end
end
