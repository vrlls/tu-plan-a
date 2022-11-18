# frozen_string_literal: true

class Category < ApplicationRecord
  has_many :places, dependent: :nullify
  has_many :events, dependent: :nullify

  validates :name, presence: true, uniqueness: { case_sensitive: true }
end
