class V1::Auth::PasswordsController < ApplicationController
  skip_before_action :authenticate_user!

  def reset
    user = User.find_by!(email: params.require(:email))
    token = user.generate_token_for(:reset_password_token)

    UserMailer.with(user: user, reset_password_token: token, redirect_url: params.require(:redirect_url)).reset_password_instructions_email.deliver_later

    render json: success_response(user: user), status: :created
  end

  def edit
    redirect_url = URI(params.require(:redirect_url))
    redirect_url.query = URI.encode_www_form({ token: params.require(:token) })

    redirect_to redirect_url
  end

  def update
    user = User.find_by_token_for!(:reset_password_token, params.require(:token))
    user.update!(password: params.require(:password))

    render json: success_response(user: user)
  end
end
