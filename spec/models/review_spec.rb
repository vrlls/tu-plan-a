# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Review do
  describe 'validations' do
    subject { create(:review) }

    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:comment) }
    it { is_expected.to validate_presence_of(:score) }
    it { is_expected.to validate_uniqueness_of(:user_id).scoped_to(:place_id).with_message('This user has already a review for this place') }
  end
end
