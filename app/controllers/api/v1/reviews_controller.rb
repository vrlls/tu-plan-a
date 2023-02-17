# frozen_string_literal: true

module Api
  module V1
    class ReviewsController < ApiController
      before_action :authenticate_user
      before_action :user

      def index
        if reviews.any?
          render json: reviews, each_serializer: ReviewSerializer, status: :ok
        else
          render json: { response: "Yo don't have any review yet" }, status: :ok
        end
      end

      private

      def reviews
        current_user.reviews.page(params[:page]).per(10)
      end


      def user
        return current_user if current_user

        render json: { error: 'Error no user' }, status: :not_found
      end
    end
  end
end
