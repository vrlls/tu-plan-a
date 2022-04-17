# frozen_string_literal: true

class CategoryPlacesSerializer
  include JSONAPI::Serializer
  set_type :place
  attributes :name, :address, :description, :score
end
