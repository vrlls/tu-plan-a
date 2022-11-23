# frozen_string_literal: true

module Api
  module V1
    class PlacesController < ApiController
      rescue_from ApiExceptions::BaseException,
      with: :render_error_response

      before_action :authenticate_user, only: %i[create edit update destroy]
      before_action :editor?, only: %i[create edit update destroy]

      def index
        options = {
          include: [:category]
        }
        render json: place_serializer(places, options), status: :ok
      end

      def show
        if place
          options = {
            include: [:category]
          }
          render json: place_serializer(place, options), status: :found
        else
          render json: { error: 'Palce not found' }, status: :not_found
        end
      end

      def create
        new_place = Place.new(place_params)

        if new_place.save
          current_user.add_role :creator, new_place
          options = {
            include: [:category]
          }
          render json: place_serializer(new_place, options), status: :created
        else
          render json: { error: 'Error creating place' }, status: :unprocessable_entity
        end
      end

      def destroy
        if place.destroy
          render json: { message: 'Place was successfully destroyed' }, status: :no_content
        else
          render json: { error: 'Error destroying place' }, status: :unprocessable_entity
        end
      end

      def update
        if place.update(place_params)
          options = {
            include: [:category]
          }
          render json: place_serializer(place, options), status: :ok
        else
          render json: { error: 'Error updating place' }, status: :unprocessable_entity
        end
      end

      private

      def places
        Place.all.includes(%i[cover_attachment thumbnails_attachments category])
      end

      def place
        Place.find(params[:id])
      end

      def editor?
        valid_roles = %w[admin editor]
        raise ApiExceptions::PermitError::InsufficientPermitsError unless current_user.roles.pluck(:name).select { |role| valid_roles.include?(role) }.any?
      end

      def place_params
        params.require(:place).permit(:name, :description, :address, :category_id, :cover, thumbnails: [])
      end
    end
  end
end
