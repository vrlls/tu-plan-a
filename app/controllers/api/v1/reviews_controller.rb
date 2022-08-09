# frozen_string_literal: true

module Api
  module V1
    class ReviewsController < ApplicationController
      before_action :user

      def index
        render json: palce_reviews_serializer(reviews), status: :ok
      end

      private

      def reviews
        Reviews.where(user: current_user)
      end

      def user
        return current_user if current_user

        render json: { error: 'Error no user' }, status: :not_found
      end

      def place_reviews_serializer(data)
        PlaceReviewsSerializer.new(data).serializable_hash.to_json
      end
    end
  end
end
