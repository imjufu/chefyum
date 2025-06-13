class User < ApplicationRecord
  include Authenticatable
  include Macroable

  PROFILES = {
    admin: "admin",
    basic: "basic"
  }.freeze

  validates :name, presence: true
  validates :profile, inclusion: { in: PROFILES.keys.map(&:to_s) }

  attribute :profile, :string, default: PROFILES[:basic]

  def is_admin?
    profile == PROFILES[:admin]
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
