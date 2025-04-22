class ApplicationController < ActionController::API
  include JsonResponseConcern
  include Pagy::Backend

  attr_reader :current_user

  before_action :authenticate_user!

  after_action { pagy_headers_merge(@pagy) if @pagy }

  rescue_from ActionController::ParameterMissing do |exception|
    render json: error_response([ exception.message ]), status: :bad_request
  end

  rescue_from ActiveRecord::RecordNotFound do |exception|
    render json: error_response([ "not_found" ]), status: :not_found
  end

  rescue_from ActiveSupport::MessageVerifier::InvalidSignature do |exception|
    render json: error_response([ "invalid_signature" ]), status: :unauthorized
  end

  rescue_from Pagy::OverflowError do |exception|
    render json: error_response([ "invalid_page" ]), status: :not_found
  end

  rescue_from CanCan::AccessDenied do |exception|
    render json: error_response([ "unauthorized" ]), status: :unauthorized
  end

  def authenticate_user!
    bearer_token = request.headers["Authorization"]
    access_token = bearer_token&.split&.last # Removes the 'Bearer' from the string

    # TODO: JWT revocation strategies
    # https://waiting-for-dev.github.io/blog/2017/01/24/jwt_revocation_strategies
    @current_user = User.find_by_token_for(:access_token, access_token)

    render json: error_response([ :unauthenticated ]), status: :unauthorized unless @current_user
  end
end
