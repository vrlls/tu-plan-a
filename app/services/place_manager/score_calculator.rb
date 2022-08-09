# frozen_string_literal: true

module PlaceManager
  class ScoreCalculator < ApplicationService
    attr_reader :place_id

    def initialize(place_id)
      @place = Place.find(place_id)
    end

    def call
      review_scores = Review.where(place: @place).pluck(:score)
      @place.update(score: (review_scores.sum / review_scores.size).ceil(1))
    end
  end
end
