# frozen_string_literal: true

module Api
  class ApiController < ActionController::API
    include Knock::Authenticable

    def favorite_serializer(data)
      FavoriteSerializer.new(data).serializable_hash.to_json
    end

    def render_error_response(error)
      render json: { status: error.status, code: error.code, message: error.message }, status: error.code
    end
  end
end
