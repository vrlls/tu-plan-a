# frozen_string_literal: true

class User < ApplicationRecord
  rolify
  VALID_ROLES = %i[admin newuser editor moderator].freeze
  has_secure_password
  has_many :favorites, dependent: :destroy
  has_many :places, through: :favorites
  validates :username, presence: true
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i.freeze
  validates :email, presence: true, uniqueness: true, format: { with: VALID_EMAIL_REGEX }
  validate :must_have_a_role, on: :update

  after_create :assign_default_role

  private

  def assign_default_role
    add_role(:newuser) if roles.blank?
  end

  def must_have_a_role
    errors.add(:roles, 'must have at least 1 role') unless roles.any?
  end
end
