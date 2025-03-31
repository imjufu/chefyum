# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CalorieCalculator do
  subject(:calorie_calc) do
    described_class.new({
                          gender: 'male',
                          birthdate: 39.years.ago,
                          height_in_centimeters: 180,
                          weight_in_kilograms: 80,
                          activity_level: 'moderately_active'
                        })
  end

  describe '#tdee' do
    it 'returns an integer' do
      expect(calorie_calc.tdee).to be_an Integer
    end

    it 'returns the TDEE' do
      expect(calorie_calc.tdee).to eq(2689)
    end

    context 'when the object is invalid' do
      before { calorie_calc.gender = 'unknown' }

      it 'returns false' do
        expect(calorie_calc.tdee).to be false
      end
    end
  end

  describe '#bmr' do
    it 'returns an integer' do
      expect(calorie_calc.bmr).to be_an Integer
    end

    it 'returns the BMR' do
      expect(calorie_calc.bmr).to eq(1735.0)
    end

    context 'when the object is invalid' do
      before { calorie_calc.gender = 'unknown' }

      it 'returns false' do
        expect(calorie_calc.bmr).to be false
      end
    end
  end
end
