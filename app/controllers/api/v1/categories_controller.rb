# frozen_string_literal: true

module Api
  module V1
    class CategoriesController < ApiController
      def index
        render json: category_serializer(categories), status: :ok
      end

      def show
        render json: category_serializer(category), status: :ok
      end

      def create
        category = Category.create(category_params)

        if category.save
          render json: category_serializer(category), status: :created
        else
          render json: { error: 'Error creating category' }, status: :unprocessable_entity
        end
      end

      private

      def categories
        Category.all
      end

      def category_params
        params.require(:categories).permit(:name)
      end

      def category
        Category.find(params[:id])
      end

      def category_serializer(categories)
        CategorySerializer.new(categories).serializable_hash.to_json
      end
    end
  end
end
