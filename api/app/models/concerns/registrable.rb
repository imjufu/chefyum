module Registrable
  extend ActiveSupport::Concern

  included do
    after_create :notify_registration

    def notify_registration
      ActiveSupport::Notifications.instrument "user.registered", { id: id, redirect_url: confirmation_redirect_url }
    end
  end
end
