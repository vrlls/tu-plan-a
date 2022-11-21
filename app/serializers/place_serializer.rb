# frozen_string_literal: true

class PlaceSerializer
  include JSONAPI::Serializer
  attributes :name, :address, :description, :score
  belongs_to :category

  attribute :cover_url do |object|
    Rails.application.routes.url_helpers.rails_blob_url(object.cover, only_path: true) if object.cover.attached?
  end

  attribute :thumb_nails_urls do |object|
    object.thumbnails.map do |image|
      Rails.application.routes.url_helpers.rails_blob_url(image, only_path: true) if object.thumbnails.attached?
    end
  end
end
