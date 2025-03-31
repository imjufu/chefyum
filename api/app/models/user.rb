class User < ApplicationRecord
  include Authenticatable

  validates :name, presence: true

  def age
    AgeCalculator.new(birthdate).calculate
  end

  def macro_calc
    return @macro_calc if @macro_calc

    macro_calc = MacroCalculator.new(
      gender:,
      birthdate:,
      height_in_centimeters:,
      weight_in_kilograms: weight_in_grams / 1000,
      activity_level:
    )

    @macro_calc = macro_calc.calculate ? macro_calc : false
  end

  def as_json(options = nil)
    super({ only: [ :id, :name, :email ] }.merge(options || {}))
  end
end
