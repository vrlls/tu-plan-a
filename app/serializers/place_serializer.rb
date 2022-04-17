# frozen_string_literal: true

class PlaceSerializer
  include JSONAPI::Serializer
  attributes :name, :address, :description, :score
  belongs_to :category
end
