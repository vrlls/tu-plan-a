# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users::Favorites' do
  def authenticated_header(user)
    token = Knock::AuthToken.new(payload: { sub: user.id }).token
    { Authorization: "Bearer #{token}" }
  end

  describe 'GET /index' do
    subject(:get_favorite_places) { get api_v1_user_favorites_path(user), headers: authenticated_header(user) }

    let(:user) { create(:user) }
    let(:place) { create(:place) }
    let(:favorites) { create(:favorite, user: user, place: place) }

    before do
      favorites
      get_favorite_places
    end

    it { expect(response).to have_http_status(:ok) }
    it { expect(json).to eq(JSON.parse(response.body)) }
  end

  describe 'POST /create' do
    subject(:post_favorite_places) { post api_v1_user_favorites_path(user), params: favorite_params, headers: authenticated_header(user) }

    let(:user) { create(:user) }
    let(:place) { create(:place) }
    let(:favorite_params) { { favorite: { place_id: place.id } } }

    it { expect { post_favorite_places }.to change(Favorite, :count).by(1) }
  end

  describe 'DELETE /destroy' do
    subject(:remove_favorite_places) { delete api_v1_user_favorite_path(user, place), headers: authenticated_header(user) }

    let!(:user) { create(:user) }
    let!(:place) { create(:place) }
    let(:favorite) { create(:favorite, user: user, place: place) }


    before do
      favorite
      remove_favorite_places
    end

    it { expect(response).to have_http_status(:no_content) }
  end
end
