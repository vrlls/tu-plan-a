# frozen_string_literal: true

class Place < ApplicationRecord
  resourcify
  belongs_to :category, optional: true
  has_many :reviews, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many_attached :images
  has_many :creators, -> { where(roles: { name: :creator }) }, through: :roles, class_name: 'User', source: :users
  has_one_attached :cover
  has_many_attached :thumbnails

  validates :name, presence: true, uniqueness: { case_sensitive: true }
  validates :address, presence: true, uniqueness: { case_sensitive: true }
end
