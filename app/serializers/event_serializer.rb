# frozen_string_literal: true

class EventSerializer
  include JSONAPI::Serializer
  attributes :name, :location, :description
  belongs_to :category
end
