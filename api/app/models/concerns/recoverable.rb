module Recoverable
  extend ActiveSupport::Concern

  included do
    generates_token_for :reset_password_token, expires_in: 15.minutes do
      # `password_salt` (defined by `has_secure_password`) returns the salt for
      # the password. The salt changes when the password is changed, so the token
      # will expire when the password is changed.
      password_salt&.last(10)
    end
  end
end