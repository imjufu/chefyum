module Lockable
  extend ActiveSupport::Concern

  included do
    generates_token_for :unlock_token, expires_in: 1.hour do
      locked_at
    end

    def lock_access!
      self.locked_at = Time.now.utc
      save(validate: false)
    end

    def unlock_access!
      reset_lock_access_fields
      save(validate: false)
    end

    def reset_lock_access_fields
      self.locked_at = nil
      self.failed_attempts = 0
    end

    def increment_failed_attempts!
      self.failed_attempts ||= 0
      self.failed_attempts += 1

      if !access_locked? && attempts_exceeded?
        lock_access!
      else
        save(validate: false)
      end
    end

    def access_locked?
      !!locked_at && !lock_expired?
    end

    protected

    def lock_expired?
      locked_at && locked_at < self.class.unlock_in.ago
    end

    def attempts_exceeded?
      self.failed_attempts >= self.class.maximum_attempts
    end

    def last_attempt?
      self.failed_attempts == self.class.maximum_attempts - 1
    end
  end

  class_methods do
    mattr_accessor :maximum_attempts, default: 20
    mattr_accessor :unlock_in, default: 1.hour
  end
end
