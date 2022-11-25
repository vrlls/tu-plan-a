# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Favorite do
  describe 'associations' do
    subject { create(:favorite) }

    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:place) }
  end
end
