class V1::Auth::SessionsController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :create ]

  def create
    user = User.find_by(email: params.fetch(:email))

    if user&.authenticate(params.fetch(:password), request.remote_ip)
      token = user.generate_token_for(:access_token)
      render json: success_response(user: user, access_token: token)
    else
      render json: error_response([ user.unauthenticated_message ]), status: :unauthorized
    end
  end

  def destroy
    @current_user
  end
end
