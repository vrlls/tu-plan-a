# frozen_string_literal: true

module Api
  module V1
    module Places
      class ReviewsController < ApplicationController
        # before_action :authenticate_user, only: %i[update create destroy]
        before_action :place

        def index
          render json: place_reviews_serializer(reviews), status: :ok
        end

        def show
          if review
            render json: place_reviews_serializer(review), status: :ok
          else
            render json: { error: 'Review not found' }, status: :not_found
          end
        end

        def create
          review = Review.new(review_params)
          review.place = place
          review.user = current_user
          if review.save
            PlaceManager::ScoreCalculator.call(review.place.id)
            render json: place_reviews_serializer(review), status: :created
          else
            render json: review.errors, status: :unprocessable_entity
          end
        end

        def update
          review = Review.find(params[:id])

          if review.user == current_user
            if review.update(review_params)
              PlaceManager::ScoreCalculator.call(review.place.id)
              render json: place_reviews_serializer(review), status: :ok
            else
              render json: review.errors, status: :unprocessable_entity
            end
          else
            render json: { error: 'You cant update another users reviews' }, status: :unprocessable_entity
          end
        end

        def destroy
            review.destroy if review.user == current_user
            render json: { error: 'You cant detroy another users reviews' }, status: :no_content
        rescue
            render json: { error: 'Error destroying review' }, status: :unprocessable_entity
        end

        private

        def reviews
          Review.where(place: place)
        end

        def review
          Review.find_by(id: params[:id])
        end

        def place
          Place.find(params[:place_id])
        end

        def place_reviews_serializer(data)
          PlaceReviewsSerializer.new(data).serializable_hash.to_json
        end

        def review_params
          params.require(:review).permit(:title, :comment, :score)
        end
      end
    end
  end
end
