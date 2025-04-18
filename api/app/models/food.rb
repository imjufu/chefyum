class Food < ApplicationRecord
  validates :source, :source_label, :source_code, presence: true
  validates :source_code, uniqueness: { scope: :source }
  validate :nutrition_facts_format

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
    # nutrition_facts is a hash with the following keys:
    # :energy, :proteins, :carbohydrates, :lipids, :sugars,
    # :saturated_fatty_acids, :salt and :fibers
    required_keys = [ "energy", "proteins", "carbohydrates", "lipids", "sugars", "saturated_fatty_acids", "salt", "fibers" ]
    errors.add(:nutrition_facts, "must have all the following keys: #{required_keys.join(', ')}") unless nf_json.keys.tally == required_keys.tally
  rescue JSON::ParserError, TypeError
    errors.add(:nutrition_facts, "is invalid")
  end
end
