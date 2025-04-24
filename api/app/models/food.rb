class Food < ApplicationRecord
  validates :source, :source_label, :source_code, presence: true
  validates :source_code, uniqueness: { scope: :source }
  validate :nutrition_facts_format

  NUTRITIONAL_COMPOSITION = [
    "energy_in_kcal_per_100g",
    "proteins_in_g_per_100g",
    "carbohydrates_in_g_per_100g",
    "lipids_in_g_per_100g",
    "sugars_in_g_per_100g",
    "saturated_fatty_acids_in_g_per_100g",
    "salt_in_g_per_100g",
    "fibers_in_g_per_100g"
  ]

  def label
    l = read_attribute(:label)
    l.blank? ? source_label : l
  end

  protected

  def nutrition_facts_format
    nf_json = JSON.parse(
      if nutrition_facts.is_a?(Hash)
        nutrition_facts.to_json
      elsif nutrition_facts.is_a?(String)
        nutrition_facts.strip
      end
    )
    raise TypeError unless nf_json.is_a?(Hash)
    errors.add(:nutrition_facts, "must have all the following keys: #{NUTRITIONAL_COMPOSITION.join(', ')}") unless nf_json.keys.tally == NUTRITIONAL_COMPOSITION.tally
  rescue JSON::ParserError, TypeError
    errors.add(:nutrition_facts, "is invalid")
  end
end
