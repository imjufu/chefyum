module Authenticatable
  extend ActiveSupport::Concern

  included do
    include Confirmable
    include Recoverable
    include Lockable
    include Trackable
    include Registrable

    has_secure_password

    validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
    normalizes :email, with: ->(email) { email.strip.downcase }

    generates_token_for :access_token, expires_in: 1.day
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
  class UnconfirmedError < StandardError; end
  class LockedError < StandardError; end
  class InvalidError < StandardError; end
  class LastAttemptError < StandardError; end
end
