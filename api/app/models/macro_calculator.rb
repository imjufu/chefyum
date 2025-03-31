class MacroCalculator < CalorieCalculator
  include ActiveModel::API

  CALORIES_IN_1G_OF_CARBOHYDRATES = 4
  CALORIES_IN_1G_OF_LIPIDS = 9
  CALORIES_IN_1G_OF_PROTEINS = 4
  GRAMS_OF_PROTEIN_PER_KG_OF_BODY_WEIGHT = 1.8
  PERCENT_OF_TDEE_FROM_LIPIDS = 30

  def calculate
    return false unless valid?

    {
      protein_in_grams:,
      lipid_in_grams:,
      carbohydrate_in_grams:
    }
  end

  private

  def protein_in_grams
    @protein_in_grams ||= (GRAMS_OF_PROTEIN_PER_KG_OF_BODY_WEIGHT * weight_in_kilograms.to_i).round
  end

  def lipid_in_grams
    @lipid_in_grams ||= (lipid_in_calories / CALORIES_IN_1G_OF_LIPIDS).round
  end

  def carbohydrate_in_grams
    @carbohydrate_in_grams ||= (carbohydrate_in_calories / CALORIES_IN_1G_OF_CARBOHYDRATES).round
  end

  def protein_in_calories
    protein_in_grams * CALORIES_IN_1G_OF_PROTEINS
  end

  def lipid_in_calories
    tdee * PERCENT_OF_TDEE_FROM_LIPIDS / 100
  end

  def carbohydrate_in_calories
    tdee - (protein_in_calories + lipid_in_calories)
  end
end
