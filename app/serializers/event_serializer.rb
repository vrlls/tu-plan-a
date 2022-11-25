# frozen_string_literal: true

class EventSerializer
  include JSONAPI::Serializer
  attributes :name, :location, :description, :status
  belongs_to :category

  attribute :cover_url do |object|
    Rails.application.routes.url_helpers.rails_blob_url(object.cover, only_path: true) if object.cover.attached?
  end

  attribute :images_urls do |object|
    object.images.map do |image|
      Rails.application.routes.url_helpers.rails_blob_url(image, only_path: true) if object.images.attached?
    end
  end
end
