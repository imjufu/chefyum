ActiveSupport::Notifications.subscribe "user.email.changed" do |event|
  redirect_url = event.payload.fetch(:redirect_url)
  user = User.find(event.payload.fetch(:id))
  token = user.generate_token_for(:confirmation_token)

  UserMailer.with(user: user, confirmation_token: token, redirect_url: redirect_url).confirmation_instructions_email.deliver_later
end

ActiveSupport::Notifications.subscribe "user.locked" do |event|
  redirect_url = event.payload.fetch(:redirect_url)
  user = User.find(event.payload.fetch(:id))
  token = user.generate_token_for(:unlock_token)

  UserMailer.with(user: user, unlock_token: token, redirect_url: redirect_url).unlock_instructions_email.deliver_later
end
