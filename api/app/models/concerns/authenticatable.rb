module Authenticatable
  extend ActiveSupport::Concern

  included do
    include Confirmable
    include Recoverable
    include Lockable
    include Trackable
    include Registrable

    ACCESS_TOKEN_EXPIRES_IN = 1.day

    has_secure_password

    validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
    normalizes :email, with: ->(email) { email.strip.downcase }

    generates_token_for :access_token, expires_in: ACCESS_TOKEN_EXPIRES_IN

    def generate_access_token
      expires_at = ACCESS_TOKEN_EXPIRES_IN.from_now
      token = generate_token_for(:access_token)

      [ token, expires_at ]
    end
  end

  class_methods do
    def authenticate!(email, password, remote_ip)
      user = User.find_by(email: email)

      fail Auth::InvalidError unless user

      # Unlock the user if the lock is expired, no matter
      # if the user can login or not (wrong password, etc)
      user.unlock_access! if user.lock_expired?

      fail Auth::UnconfirmedError unless user.confirmed?
      fail Auth::LockedError if user.access_locked?

      if user.authenticate(password)
        user.reset_lock_access_fields
        user.track_auth(remote_ip)
        user.save(validate: false)

        return user
      end

      user.increment_failed_attempts!

      fail Auth::LastAttemptError if user.last_attempt?
      fail Auth::InvalidError
    end
  end
end

module Auth
  class UnconfirmedError < StandardError
    def initialize(msg = :auth_unconfirmed)
      super
    end
  end
  class LockedError < StandardError
    def initialize(msg = :auth_locked)
      super
    end
  end
  class InvalidError < StandardError
    def initialize(msg = :auth_invalid)
      super
    end
  end
  class LastAttemptError < StandardError
    def initialize(msg = :auth_last_attempt)
      super
    end
  end
end
