# frozen_string_literal: true

class Place < ApplicationRecord
  resourcify
  belongs_to :category, optional: true
  has_many :reviews, dependent: :destroy
  has_many_attached :images

  validates :name, presence: true, uniqueness: { case_sensitive: true }
  validates :address, presence: true, uniqueness: { case_sensitive: true }
end
