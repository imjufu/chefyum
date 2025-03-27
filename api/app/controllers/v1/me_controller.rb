class V1::MeController < ApplicationController
  def index
    render json: success_response(@current_user.as_json(
      { only: [ :id, :name, :email, :unconfirmed_email, :sign_in_count, :current_sign_in_at, :last_sign_in_at, :current_sign_in_ip, :last_sign_in_ip ] }
    ))
  end

  def update
    if @current_user.update(user_params)
      render json: success_response(@current_user)
    else
      render json: error_response(@current_user.errors.full_messages), status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password)
  end
end
