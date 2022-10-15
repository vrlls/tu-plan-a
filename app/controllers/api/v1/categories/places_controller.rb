# frozen_string_literal: true

module Api
  module V1
    module Categories
      class PlacesController < ApplicationController
        before_action :category

        def index
          render json: category_places_serializer(places), status: :ok
        end

        private

        def places
          Place.where(category: category)
        end

        def category
          Category.find(params[:category_id])
        end
      end
    end
  end
end
