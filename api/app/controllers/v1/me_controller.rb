class V1::MeController < ApplicationController
  def index
    render json: success_response(current_user.as_json(with_security_data: true, with_macro_data: true))
  end

  def update
    if current_user.update(user_params)
      render json: success_response(current_user)
    else
      render json: error_response(current_user.errors.full_messages), status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :gender, :birthdate, :height_in_centimeters, :weight_in_kilograms, :activity_level)
  end
end
