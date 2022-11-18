# frozen_string_literal: true

class Review < ApplicationRecord
  belongs_to :user
  belongs_to :place, optional: true
  belongs_to :event, optional: true

  validates :user_id, uniqueness: { scope: :place_id, message: :has_a_review }
  validates :title, presence: true
  validates :comment, presence: true
  validates :score, presence: true
  validate :place_or_event_present
  validate :just_place_or_event

  after_commit :calculate_score

  private

  def place_or_event_present
    errors.add(:place_or_event, "can't be blank") unless place.present? || event.present?
  end

  def just_place_or_event
    errors.add(:place_and_event, "can't be in the same review") if place.present? && event.present?
  end

  def calculate_score
    PlaceManager::ScoreCalculator.call(place.id) if place
  end
end
