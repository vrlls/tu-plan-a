# frozen_string_literal: true

module Api
  module V1
    module Categories
      class PlacesController < ApiController

        def index
          render json: places, each_serializer: PlaceSerializer, status: :ok
        end

        private

        def places
          Category.find(params[:category_id]).places.page(params[:page]).per(10)
        end
      end
    end
  end
end
