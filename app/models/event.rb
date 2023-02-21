# frozen_string_literal: true

class Event < ApplicationRecord
  include AASM
  include CategoriesValidation

  aasm column: 'status' do
  end
  include AASM
  resourcify
  acts_as_taggable_on :categories
  belongs_to :category, optional: true

  has_one_attached :cover
  has_many_attached :images

  validates :name, presence: true, uniqueness: { case_sensitive: true }
  validates :description, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true
  validate :valid_dates
  before_create :categories_validation

  aasm do
    state :on_hold, initial: true
    state :active, :canceled, :postponed, :finished

    event :activate do
      transitions from: %i[on_hold postponed], to: :active
    end

    event :cancel do
      transitions from: %i[on_hold active postponed], to: :canceled
    end

    event :postpone do
      transitions from: %i[on_hold active], to: :postponed
    end

    event :finish do
      transitions from: :active, to: :finished
    end
  end

  private

  def valid_dates
    errors.add(:end_date, "can't be in the past") if start_date.present? && end_date.present? && start_date >= end_date
  end

  def new_status
    status
  end
end
