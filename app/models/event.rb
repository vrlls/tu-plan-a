# frozen_string_literal: true

class Event < ApplicationRecord
  resourcify
  belongs_to :category

  has_one_attached :cover
  has_many_attached :images

  validates :name, presence: true, uniqueness: { case_sensitive: true }
  validates :description, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true
  validate :valid_dates

  private

  def valid_dates
    errors.add(:end_date, "can't be in the past") if start_date.present? && end_date.present? && start_date >= end_date
  end
end
