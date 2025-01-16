class V1::Auth::UnlocksController < ApplicationController
  skip_before_action :authenticate_user!

  def unlock_request
    user = User.find_by!(email: params.fetch(:email))

    return render(json: error_response([ :already_unlocked ]), status: :unprocessable_entity) unless user.access_locked?

    token = user.generate_token_for(:unlock_token)
    redirect_url = params.fetch(:redirect_url)

    return render(json: error_response([ :redirect_url_not_allowed ]), status: :unprocessable_entity) if blacklisted_redirect_url?(redirect_url)

    UserMailer.with(user: user, unlock_token: token, redirect_url: redirect_url).unlock_instructions_email.deliver_later
  end

  def unlock
    user = User.find_by_token_for!(:unlock_token, params.fetch(:token))
    user.unlock_access!

    redirect_to URI(params.fetch(:redirect_url))
  end

  private

  def blacklisted_redirect_url?(redirect_url)
    redirect_whitelist = [ "http://localhost:4000/unlock" ]
    !redirect_whitelist.include?(redirect_url)
  end
end
