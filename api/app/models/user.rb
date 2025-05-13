class User < ApplicationRecord
  include Authenticatable

  PROFILES = {
    admin: "admin",
    basic: "basic"
  }.freeze

  validates :name, presence: true
  validates :activity_level, inclusion: { in: CalorieCalculator::ACTIVITY_LEVELS.keys.map(&:to_s) }, allow_blank: true
  validates :gender, inclusion: { in: CalorieCalculator::GENDERS.keys.map(&:to_s) }, allow_blank: true
  validates :height_in_centimeters, :weight_in_grams, numericality: { only_integer: true }, allow_blank: true
  validates :profile, inclusion: { in: PROFILES.keys.map(&:to_s) }

  attribute :profile, :string, default: PROFILES[:basic]

  def age
    AgeCalculator.new(birthdate).calculate
  end

  def is_admin?
    profile == PROFILES[:admin]
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

  def as_json(options = nil, with_security_data: false, with_macro_data: false)
    attrs = [ :id, :name, :email, :unconfirmed_email, :gender, :birthdate, :height_in_centimeters, :weight_in_grams, :activity_level ]
    if with_security_data
      attrs += [ :sign_in_count, :current_sign_in_at, :last_sign_in_at, :current_sign_in_ip, :last_sign_in_ip ]
    end
    if with_macro_data && macro
      options ||= {}
      if options.include? :methods
        options[:methods] << :macro
      else
        options[:methods] = [ :macro ]
      end
    end
    super({ only: attrs }.merge(options || {}))
  end
end
