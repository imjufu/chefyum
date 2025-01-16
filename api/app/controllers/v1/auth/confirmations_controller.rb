class V1::Auth::ConfirmationsController < ApplicationController
  skip_before_action :authenticate_user!

  def confirmation_request
    user = User.find_by!(email: params.fetch(:email))

    return render(json: error_response([ :already_confirmed ]), status: :unprocessable_entity) if user.confirmed?

    token = user.generate_token_for(:confirmation_token)
    redirect_url = params.fetch(:redirect_url)

    return render(json: error_response([ :redirect_url_not_allowed ]), status: :unprocessable_entity) if blacklisted_redirect_url?(redirect_url)

    UserMailer.with(user: user, confirmation_token: token, redirect_url: redirect_url).confirmation_instructions_email.deliver_later
  end

  def confirmation
    user = User.find_by_token_for!(:confirmation_token, params.fetch(:token))
    user.confirm!

    redirect_to URI(params.fetch(:redirect_url))
  end

  private

  def blacklisted_redirect_url?(redirect_url)
    redirect_whitelist = [ "http://localhost:4000/confirm" ]
    !redirect_whitelist.include?(redirect_url)
  end
end
