# frozen_string_literal: true

class ReviewSerializer < ActiveModel::Serializer
  attributes :id, :title, :comment, :score, :for
  belongs_to :user
  belongs_to :place, optional: true
  belongs_to :event, optional: true

  def for
    if object.place_id.present?
      "place"
    elsif object.event_id.present?
      "event"
    else
      "unknown"
    end
  end
end
