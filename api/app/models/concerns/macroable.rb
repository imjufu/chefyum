module Macroable
  extend ActiveSupport::Concern

  included do
    attribute :gender, :string
    attribute :birthdate, :date
    attribute :activity_level, :string
    attribute :height_in_centimeters, :integer
    attribute :weight_in_grams, :integer

    validates :activity_level, inclusion: { in: CalorieCalculator::ACTIVITY_LEVELS.keys.map(&:to_s) }, allow_blank: true
    validates :gender, inclusion: { in: CalorieCalculator::GENDERS.keys.map(&:to_s) }, allow_blank: true
    validates :height_in_centimeters, :weight_in_grams, numericality: { only_integer: true }, allow_blank: true
    validate :macro_related_data_format

    before_validation :update_macro_related_data
    after_initialize :update_macro_related_attrs

    def age
      AgeCalculator.new(birthdate).calculate
    end

    def macro
      return @macro if @macro

      macro_calculator = MacroCalculator.new(
        gender:,
        birthdate:,
        height_in_centimeters:,
        weight_in_kilograms: weight_in_grams ? weight_in_grams / 1000 : nil,
        activity_level:
      )

      @macro = macro_calculator.calculate
    end

    private

    def update_macro_related_data
      self.macro_related_data = {
        gender:,
        birthdate:,
        height_in_centimeters:,
        weight_in_grams:,
        activity_level:
      }
    end

    def update_macro_related_attrs
      self.assign_attributes(macro_related_data || {})
    end

    def macro_related_data_format
      vs_json = JSON.parse(
        if macro_related_data.is_a?(Hash)
          macro_related_data.to_json
        elsif macro_related_data.is_a?(String)
          macro_related_data.strip
        end
      )
      raise TypeError unless vs_json.is_a?(Hash)
    rescue JSON::ParserError, TypeError
      errors.add(:macro_related_data, "is invalid")
    end
  end
end
