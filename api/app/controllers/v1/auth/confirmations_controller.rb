class V1::Auth::ConfirmationsController < ApplicationController
  skip_before_action :authenticate_user!

  def confirmation_request
    user = User.find_by!(unconfirmed_email: params.require(:email))
    user.confirmation_redirect_url = params.require(:redirect_url)
    user.notify_reconfirmation

    render json: success_response(user: user)
  end

  def confirmation
    user = User.find_by_token_for!(:confirmation_token, params.require(:token))
    user.confirm!

    redirect_to URI(params.require(:redirect_url))
  end
end
