# frozen_string_literal: true

class Category < ApplicationRecord
  has_many :places, dependent: :nullify

  validates :name, presence: true, uniqueness: { case_sensitive: true }
end
