class UserMailer < ApplicationMailer
  def reset_password_instructions_email
    @user = params[:user]
    @token = params[:reset_password_token]
    @redirect_url = params[:redirect_url]
    mail(to: @user.email, subject: "Password reset instructions")
  end

  def unlock_instructions_email
    @user = params[:user]
    @token = params[:unlock_token]
    @redirect_url = params[:redirect_url]
    mail(to: @user.email, subject: "Unlock instructions")
  end

  def confirmation_instructions_email
    @user = params[:user]
    @token = params[:confirmation_token]
    @redirect_url = params[:redirect_url]
    mail(to: @user.unconfirmed_email, subject: "Confirmation instructions")
  end

  def welcome_email
    @user = params[:user]
    @token = params[:confirmation_token]
    @redirect_url = params[:redirect_url]
    mail(to: @user.email, subject: "Welcome")
  end
end
