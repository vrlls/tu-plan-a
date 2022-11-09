# frozen_string_literal: true

class FavoriteSerializer
  include JSONAPI::Serializer

  belongs_to :place
  belongs_to :user
end
