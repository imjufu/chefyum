class V1::SignUpController < ApplicationController
  skip_before_action :authenticate_user!

  def create
    user = User.new(user_params)
    user.confirmation_redirect_url = params.fetch(:redirect_url)

    if user.save
      render json: success_response(user), status: :created
    else
      render json: model_error_response(user), status: :bad_request
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password)
  end
end
