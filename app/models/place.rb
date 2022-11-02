# frozen_string_literal: true

class Place < ApplicationRecord
  resourcify
  belongs_to :category, optional: true
  has_many :reviews, dependent: :destroy
  has_many_attached :images

  validates :name, presence: true, uniqueness: { case_sensitive: true }
  validates :address, presence: true, uniqueness: { case_sensitive: true }

  after_create :set_creator
  after_commit :calculate_score

  private

  def set_creator
    current_user.add_role :creator, self
  end
end
