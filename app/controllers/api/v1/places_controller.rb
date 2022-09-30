# frozen_string_literal: true

module Api
  module V1
    class PlacesController < ApplicationController
      def index
        render json: place_serializer(places), status: :ok
      end

      def show
        if place
          render json: place_serializer(place), status: :found
        else
          render json: { error: 'Palce not found' }, status: :not_found
        end
      end

      def create
        new_place = Place.new(place_params)
        new_place.images.attach(place_params[:images])

        if new_place.save
          render json: place_serializer(new_place), status: :created
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
          render json: place_serializer(place), status: :ok
        else
          render json: { error: 'Error updating place' }, status: :unprocessable_entity
        end
      end

      private

      def places
        Place.all
      end

      def place
        Place.find(params[:id])
      end

      def place_params
        params.require(:place).permit(:name, :description, :address, :category_id, :images)
      end

      def place_serializer(data)
        PlaceSerializer.new(data).serializable_hash.to_json
      end
    end
  end
end
