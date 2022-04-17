# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Categories::Places', type: :request do
  describe 'GET /index' do
    subject(:get_places) { get api_v1_category_places_path(category) }

    let!(:category) { create(:category) }
    let(:places) { create_list(:place, 2, category: category) }
    # let(:place2) { create(:place, category: category) }

    before do
      places
      get_places
    end

    it { expect(response).to have_http_status(:ok) }
    it { expect(json).to eq(json(CategoryPlacesSerializer.new(places).serializable_hash.to_json)) }
  end
end
