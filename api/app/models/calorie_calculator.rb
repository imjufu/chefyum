class CalorieCalculator
  include ActiveModel::API

  GENDERS = {
    female: -161,
    male: 5
  }.freeze

  ACTIVITY_LEVELS = {
    sedentary: 1.2,
    lightly_active: 1.375,
    moderately_active: 1.55,
    active: 1.725,
    very_active: 1.9
  }.freeze

  attr_accessor :gender, :birthdate, :height_in_centimeters, :weight_in_kilograms, :activity_level

  validates :birthdate, presence: true
  validates :gender, inclusion: { in: GENDERS.keys.map(&:to_s) }
  validates :height_in_centimeters, :weight_in_kilograms, numericality: { greater_than: 0, only_integer: true }
  validates :activity_level, inclusion: { in: ACTIVITY_LEVELS.keys.map(&:to_s) }

  def tdee
    # TDEE = Total Daily Energy Expenditure
    return @tdee if @tdee

    tdee = calculate_tdee
    @tdee = tdee ? tdee.to_i : tdee
  end

  def bmr
    # BMR = Basal Metabolic Rate
    return @bmr if @bmr

    bmr = calculate_bmr
    @bmr = bmr ? bmr.to_i : bmr
  end

  def age
    AgeCalculator.new(birthdate).calculate
  end

  private

  def calculate_bmr
    return false unless valid?

    # Based on the Mifflin-St Jeor Formula: https://pubmed.ncbi.nlm.nih.gov/2305711/
    # Simplification of this formula and separation by sex did not affect its predictive value:
    # REE (males) = 10 x weight (kg) + 6.25 x height (cm) - 5 x age (y) + 5;
    # REE (females) = 10 x weight (kg) + 6.25 x height (cm) - 5 x age (y) - 161.
    (10 * (weight_in_kilograms.to_i)) + (6.25 * height_in_centimeters.to_i) - (5 * age.to_i) + GENDERS.fetch(gender.to_sym)
  end

  def calculate_tdee
    return false unless bmr

    bmr * ACTIVITY_LEVELS.fetch(activity_level.to_sym)
  end
end
