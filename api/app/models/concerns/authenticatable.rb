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

    def authenticate(password, remote_ip)
      # Unlock the user if the lock is expired, no matter
      # if the user can login or not (wrong password, etc)
      unlock_access! if lock_expired?

      return false unless confirmed?

      if super(password) && !access_locked?
        reset_lock_access_fields
        track_auth(remote_ip)
        save(validate: false)

        return self
      end

      increment_failed_attempts!

      false
    end

    def unauthenticated_message
      if !confirmed?
        :unconfirmed
      elsif access_locked?
        :locked
      elsif last_attempt?
        :last_attempt
      else
        :invalid
      end
    end
  end
end
