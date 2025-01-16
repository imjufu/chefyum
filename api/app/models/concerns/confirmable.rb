module Confirmable
  extend ActiveSupport::Concern

  included do
    @bypass_confirmation_postpone = false
    @confirmation_required = false

    attr_accessor :confirmation_redirect_url

    before_save :postpone_email_change_until_confirmation, if: :postpone_email_changed?
    after_update :notify_reconfirmation, if: :confirmation_required?

    generates_token_for :confirmation_token, expires_in: 1.hour do
      unconfirmed_email
    end

    def confirm!
      if pending_reconfirmation? && !confirmation_period_expired?
        @bypass_confirmation_postpone = true

        self.confirmed_at = Time.now.utc
        self.email = unconfirmed_email
        self.unconfirmed_email = nil

        saved = save(validate: true)

        @bypass_confirmation_postpone = false

        return saved
      end

      false
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

    def notify_reconfirmation
      ActiveSupport::Notifications.instrument "user.email.changed", { id: id, redirect_url: confirmation_redirect_url }
      @confirmation_required = false
    end

    protected

    def postpone_email_change_until_confirmation
      @confirmation_required = true
      self.unconfirmed_email = email
      self.email = email_was || email
    end

    def postpone_email_changed?
      email_changed? && !@bypass_confirmation_postpone
    end

    def confirmation_required?
      @confirmation_required
    end
  end

  class_methods do
    mattr_accessor :confirm_within, default: 3.days
  end
end
