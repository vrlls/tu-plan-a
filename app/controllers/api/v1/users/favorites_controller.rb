# frozen_string_literal: true

module Api
  module V1
    module Users
      class FavoritesController < ApiController
        before_action :authenticate_user
        def index
          if favorites.empty?
            render json: { response: 'No favorite places found' }, status: :ok
          else
            render json: favorites, each_serializer: FavoriteSerializer, status: :ok
          end
        end

        def create
          favorite = Favorite.new(favorite_params)
          favorite.user = current_user

          if favorite.save
            render json: { response: 'Places added to favorites' }, status: :created
          else
            render json: favorite.errors, status: :unprocessable_entity
          end
        end

        def destroy
          favorite = current_user.favorites.find_by(place_id: params[:id])
          favorite.destroy
          render json: { response: 'Place removed from favorites' }, status: :no_content
        end

        private

        def favorites
          current_user.favorites.page(params[:page]).per(10)
        end

        def favorite_params
          params.require(:favorite).permit(:place_id)
        end
      end
    end
  end
end
