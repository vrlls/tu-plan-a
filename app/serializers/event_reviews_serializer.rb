# frozen_string_literal: true

class EventReviewsSerializer
  include JSONAPI::Serializer
  set_type :review
  attributes :title, :comment, :score
  belongs_to :user
  belongs_to :event
end
