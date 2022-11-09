# frozen_string_literal: true

module PlaceManager
  class ScoreCalculator < ApplicationService
    attr_reader :place_id

    def initialize(place_id)
      @place = Place.find(place_id)
    end

    def call
      @place.update(score: total)
    end

    private

    def total
      review_scores = Review.where(place: @place).pluck(:score)
      review_scores.any? ? (review_scores.sum / review_scores.size).ceil(1) : 0.0
    end
  end
end
