# frozen_string_literal: true

module ApiExceptions
  class PermitError < ApiExceptions::BaseException
    class InsufficientPermitsError < ApiExceptions::PermitError
    end
  end
end
