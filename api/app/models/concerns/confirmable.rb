module Confirmable
  extend ActiveSupport::Concern

  included do
    generates_token_for :confirmation_token, expires_in: 1.hour do
      unconfirmed_email
    end

    def confirm!
      if pending_reconfirmation? && !confirmation_period_expired?
        self.confirmed_at = Time.now.utc
        self.email = unconfirmed_email
        self.unconfirmed_email = nil

        return save(validate: true)
      end

      false
    end

    def pending_reconfirmation(unconfirmed_email)
      self.unconfirmed_email = unconfirmed_email
      self.confirmation_sent_at = Time.now.utc
      save(validate: false)
    end

    def pending_reconfirmation?
      unconfirmed_email.present?
    end

    def confirmed?
      !!confirmed_at
    end

    def confirmation_period_expired?
      self.confirmation_sent_at && (Time.now.utc > self.confirmation_sent_at.utc + self.class.confirm_within)
    end
  end

  class_methods do
    mattr_accessor :confirm_within, default: 3.days
  end
end