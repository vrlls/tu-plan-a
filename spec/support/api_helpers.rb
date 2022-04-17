# frozen_string_literal: true

module ApiHelpers
  def json(value = nil)
    return JSON.parse(response.body) unless value

    JSON.parse(value)
  end
end
