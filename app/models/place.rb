# frozen_string_literal: true

class Place < ApplicationRecord
  belongs_to :category, optional: true
  has_many :reviews, dependent: :destroy

  validates :name, presence: true, uniqueness: { case_sensitive: true }
  validates :address, presence: true, uniqueness: { case_sensitive: true }
end
