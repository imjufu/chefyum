class User < ApplicationRecord
  include Authenticatable

  validates :name, presence: true

  def as_json(options = nil)
    super({ only: [ :id, :name, :email ] }.merge(options || {}))
  end
end
