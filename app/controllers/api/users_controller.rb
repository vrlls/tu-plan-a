# frozen_string_literal: true

module Api
  class UsersController < ApiController
    rescue_from ApiExceptions::BaseException,
    with: :render_error_response

    before_action :authenticate_user, except: [:create]
    before_action :set_user, only: %i[show update]
    before_action :admin?, only: %i[index]

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
      new_user = User.new(user_params.except("roles"))
      if new_user.save
        UserManager::RoleSetter.call(new_user.id, user_params["roles"])
        render json: user_serializer(new_user), status: :created
      else
        render json: { error: 'Error creating user' }, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /users/1
    def update
      raise ApiExceptions::PermitError::InsufficientPermitsError unless current_user == set_user

      if set_user.update(user_params.except("roles"))
        UserManager::RoleSetter.call(new_user.id, user_params["roles"]) if user_params["roles"]
        render json: user_serializer(set_user), status: :ok
      else
        render json: { error: 'Error updating user' }, status: :unprocessable_entity
      end
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
      params.require(:user).permit(:name, :last_name, :birth_day, :username, :email, :password, :password_confirmation, { roles: [] })
    end

    def user_serializer(data)
      UserSerializer.new(data).serializable_hash.to_json
    end

    def admin?
      raise ApiExceptions::PermitError::InsufficientPermitsError unless current_user.has_role? :admin
    end
  end
end
