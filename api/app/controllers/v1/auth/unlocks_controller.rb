class V1::Auth::UnlocksController < ApplicationController
  skip_before_action :authenticate_user!

  def unlock_request
    user = User.find_by!(email: params.fetch(:email))

    return render(json: error_response([ :already_unlocked ]), status: :unprocessable_entity) unless user.access_locked?

    user.unlocked_redirect_url = params.fetch(:redirect_url)
    user.notify_locked
  end

  def unlock
    user = User.find_by_token_for!(:unlock_token, params.fetch(:token))
    user.unlock_access!

    redirect_to URI(params.fetch(:redirect_url))
  end
end
