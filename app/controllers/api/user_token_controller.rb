# frozen_string_literal: true

module Api
  class UserTokenController < Knock::AuthTokenController
    skip_before_action :verify_authenticity_token, raise: false
  end
end
