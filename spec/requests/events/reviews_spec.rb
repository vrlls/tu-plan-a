# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Events::Reviews' do
  def authenticated_header(user)
    token = Knock::AuthToken.new(payload: { sub: user.id }).token
    { Authorization: "Bearer #{token}" }
  end

  describe 'GET /index' do
    subject(:get_reviews) { get api_v1_event_reviews_path(event) }

    let!(:event) { create(:event) }
    let!(:user) { create(:user) }
    let(:reviews) { create(:review, event: event, place: nil, user: user) }

    before do
      reviews
      get_reviews
    end

    it { expect(response).to have_http_status(:ok) }

    it { expect(json).to eq(json(EventReviewsSerializer.new([reviews]).serializable_hash.to_json)) }
  end

  describe 'GET /show' do
    subject(:get_review) { get api_v1_event_review_path(event, review) }

    let!(:event) { create(:event) }
    let!(:user) { create(:user) }
    let(:review) { create(:review, event: event, place: nil, user: user) }

    before do
      review
      get_review
    end

    it { expect(response).to have_http_status(:ok) }
    it { expect(json).to eq(json(EventReviewsSerializer.new(review).serializable_hash.to_json)) }
  end

  describe 'POST /create' do
    subject(:post_review) { post api_v1_event_reviews_path(event), params: review_params, headers: authenticated_header(user) }

    let!(:user) { create(:user) }
    let!(:event) { create(:event) }
    let(:review_params) { { review: { title: 'Review title', comment: 'Review comment', score: 5.0 } } }


    it { expect { post_review }.to change(Review, :count).by(1) }
  end

  describe 'PUT /update' do
    subject(:update_review) { put api_v1_event_review_path(event, review), params: review_params, headers: authenticated_header(user) }

    let!(:event) { create(:event) }
    let!(:user) { create(:user) }
    let!(:review) { create(:review, user: user, event: event, place: nil) }
    let(:review_params) { { review: { title: 'New review title' } } }


    it 'checks that a review can be updated' do
      update_review
      expect(Review.find_by(title: 'New review title')).to eq(review)
    end
  end

  describe 'DELETE /destroy' do
    subject(:destroy_review) {}

    let!(:user) { create(:moderator) }
    let!(:event) { create(:event) }
    let(:review) { create(:review, event: event, place: nil, user: user) }


    before do
      review
      delete api_v1_event_review_path(event, review), headers: authenticated_header(user)
    end

    it { expect(response).to have_http_status(:no_content) }
  end
end
