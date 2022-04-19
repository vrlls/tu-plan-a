# frozen_string_literal: true

module Api
  class UsersController < ApplicationController
    # before_action :authenticate_user, except: [:create]
    before_action :set_user, only: %i[show update destroy]

    # GET /users
    def index
      render json: user_serializer(users), status: :ok
    end

    # GET /users/1
    def show
      render json: user_serializer(set_user), status: :found
    end

    # POST /users
    def create
      new_user = User.new(user_params)
      if new_user.save
        render json: user_serializer(new_user), status: :created
      else
        render json: { error: 'Error creating user' }, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /users/1
    def update
      if set_user.update(user_params)
        render json: user_serializer(set_user), status: :ok
      else
        render json: { error: 'Error updating user' }, status: :unprocessable_entity
      end
    end

    # DELETE /users/1
    def destroy
      set_user.destroy
    end

    private

      def users
        User.all
      end

      # Use callbacks to share common setup or constraints between actions.
      def set_user
        User.find(params[:id])
      end

      # Only allow a list of trusted parameters through.
      def user_params
        params.permit(:username, :email, :password, :password_confirmation)
      end

      def user_serializer(data)
        UserSerializer.new(data).serializable_hash.to_json
      end
  end
end
