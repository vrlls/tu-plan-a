# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:username) }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to allow_value('email@addresse.foo').for(:email) }
  it { is_expected.not_to allow_value('foo').for(:email) }
    it { is_expected.to validate_uniqueness_of(:email) }
  end
end
