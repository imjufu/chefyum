class UserMailer < ApplicationMailer
  def reset_password_instructions_email
    @user = params[:user]
    @token = params[:password_reset_token]
    @redirect_url = params[:redirect_url]
    mail(to: @user.email, subject: "Password reset instructions")
  end
end
