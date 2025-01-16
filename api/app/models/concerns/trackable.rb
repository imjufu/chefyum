module Trackable
  extend ActiveSupport::Concern

  included do
    def track_auth(remote_ip)
      old_current, new_current = self.current_sign_in_at, Time.now.utc
      self.last_sign_in_at     = old_current || new_current
      self.current_sign_in_at  = new_current

      old_current, new_current = self.current_sign_in_ip, remote_ip
      self.last_sign_in_ip     = old_current || new_current
      self.current_sign_in_ip  = new_current

      self.sign_in_count ||= 0
      self.sign_in_count += 1
    end
  end
end
