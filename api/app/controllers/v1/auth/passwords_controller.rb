class V1::Auth::PasswordsController < ApplicationController
  skip_before_action :authenticate_user!

  def reset
    user = User.find_by!(email: params.fetch(:email))
    token = user.generate_token_for(:reset_password_token)
    redirect_url = params.fetch(:redirect_url)

    return render(json: error_response([ "Redirect to '#{redirect_url}' is not allowed." ]), status: :unprocessable_entity) if blacklisted_redirect_url?(redirect_url)

    UserMailer.with(user: user, reset_password_token: token, redirect_url: redirect_url).reset_password_instructions_email.deliver_later
  end

  def edit
    redirect_url = URI(params.fetch(:redirect_url))
    redirect_url.query = URI.encode_www_form({ token: params.fetch(:token) })

    redirect_to redirect_url
  end

  def update
    user = User.find_by_token_for!(:reset_password_token, params.fetch(:token))
    user.update!(password: params.fetch(:password))

    render json: success_response(user: user)
  end

  private

  def blacklisted_redirect_url?(redirect_url)
    redirect_whitelist = [ "http://localhost:4000/password/edit" ]
    !redirect_whitelist.include?(redirect_url)
  end
end
