module Api
  module V1
    module Users
      class FavoritesController < ApplicationController
        before_action :authenticate_user
        def index
          render json: current_user.favorites, status: :ok
        end
      
        def create
          favorite = Favorite.new(favorite_params)
          favorite.user = current_user

          if favorite.save
            render json: {response: "Places added to favorites"}, status: :created
          else
            render json: favorite.errors, status: :unprocessable_entity
          end
        end
      
        def destroy
          favorite = current_user.favorites.find(params[:id])
          favorite.destroy
          render json: {response: "Place removed from favorites"}, status: :destroy
        rescue
          render json: {response: "Favorite not found"}, status: :unprocessable_entity
        end

        private
        
        def favorite

        end

        def favorite_params
          params.require(:favorite).permit(:place_id)
        end
      end
    end
  end
end
