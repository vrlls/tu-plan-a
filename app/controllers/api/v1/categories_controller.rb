# frozen_string_literal: true

module Api
  module V1
    class CategoriesController < ApiController
      before_action :authenticate_user, only: :create

      def index
        render json: categories, each_serialize: CategorySerializer, status: :ok
      end

      def show
        render json: category, serializer: CategorySerializer, status: :ok
      end

      def create
        category = Category.create(category_params)

        if category.save
          render json: category, serializer: CategorySerializer, status: :created
        else
          render json: { error: 'Error creating category' }, status: :unprocessable_entity
        end
      end

      private

      def categories
        Category.all.page(params[:page]).per(10)
      end

      def category_params
        params.require(:categories).permit(:name)
      end

      def category
        Category.find(params[:id])
      end
    end
  end
end
