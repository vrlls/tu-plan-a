# frozen_string_literal: true

module Api
  class ApplicationController < ActionController::API
    include Knock::Authenticable
  end
end
