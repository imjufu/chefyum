class ApplicationController < ActionController::API
  include JsonResponseConcern
  before_action :authenticate_user!

  def authenticate_user!
    bearer_token = request.headers["Authorization"]
    access_token = bearer_token&.split&.last # Removes the 'Bearer' from the string

    # TODO: JWT revocation strategies
    # https://waiting-for-dev.github.io/blog/2017/01/24/jwt_revocation_strategies
    @current_user = User.find_by_token_for(:access_token, access_token)

    render json: error_response([ :unauthenticated ]), status: :unauthorized unless @current_user
  end
end
