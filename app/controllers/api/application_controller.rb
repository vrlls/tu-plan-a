# frozen_string_literal: true

module Api
  class ApplicationController < ActionController::API
    include Knock::Authenticable

    def place_serializer(data)
      PlaceSerializer.new(data).serializable_hash.to_json
    end

    def place_reviews_serializer(data)
      PlaceReviewsSerializer.new(data).serializable_hash.to_json
    end

    def category_serializer(data)
      CategorySerializer.new(data).serializable_hash.to_json
    end

    def user_serializer(data)
      UserSerializer.new(data).serializable_hash.to_json
    end

    def category_places_serializer(data)
      CategoryPlacesSerializer.new(data).serializable_hash.to_json
    end

    def render_error_response(error)
      render json: { status: error.status, code: error.code, message: error.message }, status: error.code
    end
  end
end
