class PlaceSerializer < ActiveModel::Serializer
  attributes attributes :id, :name, :address, :description, :score, :cover_url, :thumb_nails_urls
  belongs_to :category

  def cover_url
    if object.cover.attached?
      Rails.application.routes.url_helpers.rails_blob_url(object.cover, only_path: true)
    end
  end

  def thumb_nails_urls
    if object.thumbnails.attached?
      object.thumbnails.map do |image|
        Rails.application.routes.url_helpers.rails_blob_url(image, only_path: true)
      end
    end
  end
end
