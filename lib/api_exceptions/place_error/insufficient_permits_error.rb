# frozen_string_literal: true

module ApiExceptions
  class PlaceError < ApiExceptions::BaseException
    class InsufficientPermitsError < ApiExceptions::PlaceError
    end
  end
end
