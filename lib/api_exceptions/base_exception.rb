# frozen_string_literal: true

module ApiExceptions
  class BaseException < StandardError
    attr_reader :status, :code, :message

    ERROR_DESCRIPTION = proc { |code, message| { status: 'error | failure', code: code, message: message } }
    ERROR_CODE_MAP = {
      'PlaceError::InsufficientPermitsError' =>
        ERROR_DESCRIPTION.call(401, 'You must be admin or editor for execute this action')
    }.freeze

    def initialize
      error_type = self.class.name.scan(/ApiExceptions::(.*)/).flatten.first
      ApiExceptions::BaseException::ERROR_CODE_MAP
        .fetch(error_type, {}).each do |attr, value|
          instance_variable_set("@#{attr}".to_sym, value)
        end
    end
  end
end
