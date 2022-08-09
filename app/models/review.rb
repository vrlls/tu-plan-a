# frozen_string_literal: true

class Review < ApplicationRecord
  belongs_to :user
  belongs_to :place

  validates :user_id, uniqueness: { scope: :place_id, message: :has_a_review }
  validates :title, presence: true
  validates :comment, presence: true
  validates :score, presence: true
end
