class V1::MeController < ApplicationController
  def index
    render json: success_response(@current_user)
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
    params.require(:user).permit(:name, :password)
  end
end
