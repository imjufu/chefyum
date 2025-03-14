class V1::Auth::ConfirmationsController < ApplicationController
  skip_before_action :authenticate_user!

  def confirmation_request
    user = User.find_by!(unconfirmed_email: params.fetch(:email))
    user.confirmation_redirect_url = params.fetch(:redirect_url)
    user.notify_reconfirmation

    render json: success_response(user: user)
  end

  def confirmation
    user = User.find_by_token_for!(:confirmation_token, params.fetch(:token))
    user.confirm!

    redirect_to URI(params.fetch(:redirect_url))
  end
end
