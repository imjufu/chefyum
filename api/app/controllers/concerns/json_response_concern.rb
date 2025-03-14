module JsonResponseConcern
  extend ActiveSupport::Concern

  included do
    def success_response(body)
      common_response(body)
    end

    def error_response(body)
      common_response({ errors: body }, success: false)
    end

    def common_response(body, success: true)
      { success: success, data: body }
    end
  end
end
