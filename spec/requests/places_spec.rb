# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Places' do
  def authenticated_header(user)
    token = Knock::AuthToken.new(payload: { sub: user.id }).token
    { Authorization: "Bearer #{token}" }
  end

  describe 'GET /index' do
    subject(:get_places) { get api_v1_places_path }

    let(:places) { create_list(:place, 5) }

    before do
      places
      get_places
    end

    it { expect(response).to have_http_status(:ok) }
    it { expect(json).not_to be_empty }
    it { expect(json.size).to eq(5) }
  end

  describe 'POST /create' do
    subject(:post_place) { post api_v1_places_path(place_params), headers: authenticated_header(user) }

    let!(:user) { create(:editor) }
    let(:category) { create(:category) }
    let(:place_params) { { 'place' => { 'name' => 'Test', 'address' => '282 Kevin Brook, Imogeneborough, CA 58517', 'description' => 'Test description', 'category_id' => category } } }

    it { expect { post_place }.to change(Place, :count).by(1) }

    it 'Role creator added' do
      post_place
      expect(user.roles.pluck(:name)).to be_truthy
    end
  end

  describe 'GET /show' do
    let(:place) { create(:place) }

    before do
      place
      get api_v1_place_path(place.id)
    end

    it { expect(json['id'].to_i).to eq(place.id) }
  end

  describe 'DELETE /destroy' do
    let(:place) { create(:place) }
    let!(:user) { create(:editor) }

    before do
      place
      delete api_v1_place_path(place.id), headers: authenticated_header(user)
    end

    it { expect(response).to have_http_status(:no_content) }
  end

  describe 'PUT /update' do
    let(:place) { create(:place) }
    let(:place_params) { { 'place' => { 'name' => 'New name' } } }
    let!(:user) { create(:editor) }

    before do
      place
      put api_v1_place_path(place.id, place_params), headers: authenticated_header(user)
    end

    it { expect(response).to have_http_status(:ok) }
    it { expect(json['name']).to eq('New name') }
  end
end
