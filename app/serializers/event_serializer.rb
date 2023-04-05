# frozen_string_literal: true

class EventSerializer < ActiveModel::Serializer
  attributes :id, :name, :location, :description, :status, :cover_url, :iamges_urls, :category_list

  def cover_url
    if object.cover.attached?
      Rails.application.routes.url_helpers.rails_blob_url(object.cover, only_path: true)
    end
  end

  def iamges_urls
    if object.images.attached?
      object.images.map do |image|
        Rails.application.routes.url_helpers.rails_blob_url(image, only_path: true)
      end
    end
  end
end
