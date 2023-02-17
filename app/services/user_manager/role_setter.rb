# frozen_string_literal: true

module UserManager
  class RoleSetter < ApplicationService
    attr_reader :user_id

    def initialize(user_id, roles)
      @user = User.find(user_id)
      @roles = roles.map(&:to_sym)
    end

    def call
      add_roles
    end

    private

    def add_roles
      @roles.each do |role|
        @user.add_role role if User::VALID_ROLES.include?(role)
      end
    end
  end
end
