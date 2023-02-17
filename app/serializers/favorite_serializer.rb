# frozen_string_literal: true

class FavoriteSerializer < ActiveModel::Serializer
  attribute :id
  belongs_to :place
end
