# frozen_string_literal: true

module Api
  module V1
    class PlacesController < ApiController
      rescue_from ApiExceptions::BaseException,
      with: :render_error_response

      before_action :authenticate_user, only: %i[create edit update destroy]
      before_action :editor?, only: %i[create edit update destroy]

      def index
        if params[:category_list]
          render json: filtered_places, each_serializer: PlaceSerializer, status: :ok
        else
          render json: places, each_serializer: PlaceSerializer, status: :ok
        end
      end

      def show
        if place
          options = {
            include: [:category]
          }
          render json: place, serializer: PlaceSerializer, status: :found
        else
          render json: { error: 'Palce not found' }, status: :not_found
        end
      end

      def create
        new_place = Place.new(place_params)

        if new_place.save
          current_user.add_role :creator, new_place
          render json: new_place, serializer: PlaceSerializer, status: :created
        else
          render json: { error: 'Error creating place' }, status: :unprocessable_entity
        end
      end

      def update
        if place.update(place_params)
          options = {
            include: [:category]
          }
          render json: place, serializer: PlaceSerializer, status: :ok
        else
          render json: { error: 'Error updating place' }, status: :unprocessable_entity
        end
      end

      def destroy
        if place.destroy
          render json: { message: 'Place was successfully destroyed' }, status: :no_content
        else
          render json: { error: 'Error destroying place' }, status: :unprocessable_entity
        end
      end

      private

      def places
        Place.all.includes(%i[cover_attachment thumbnails_attachments category]).page(params[:page]).per(10)
      end

      def filtered_places
        Place.tagged_with(params[:category_list], :any => true).includes(%i[cover_attachment thumbnails_attachments category]).page(params[:page]).per(10)
      end

      def place
        Place.find(params[:id])
      end

      def editor?
        valid_roles = %w[admin editor]
        raise ApiExceptions::PermitError::InsufficientPermitsError unless current_user.roles.pluck(:name).select { |role| valid_roles.include?(role) }.any?
      end

      def place_params
        params.require(:place).permit(:name, :description, :address, :category_list, :cover, thumbnails: [])
      end
    end
  end
end
