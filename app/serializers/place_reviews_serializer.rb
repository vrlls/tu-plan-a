# frozen_string_literal: true

class PlaceReviewsSerializer
  include JSONAPI::Serializer
  set_type :review
  attributes :title, :comment, :score, :user, :place
end
