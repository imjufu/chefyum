class V1::Auth::SessionsController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :create ]

  def create
    begin
      user = User.authenticate!(
        params.require(:email),
        params.require(:password),
        request.remote_ip,
        params.require(:unlocked_redirect_url)
        )
      token, expires_at = user.generate_access_token
    rescue StandardError => error
      return render json: error_response([ error.message ]), status: :bad_request
    end

    render json: success_response(
      user: user,
      access_token: token,
      expires_at: expires_at
    ), status: :created
  end

  def destroy
    current_user
  end
end
