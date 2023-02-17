# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Categories' do
  def authenticated_header(user)
    token = Knock::AuthToken.new(payload: { sub: user.id }).token
    { Authorization: "Bearer #{token}" }
  end

  describe 'GET /index' do
    subject(:get_categories) { get api_v1_categories_path }

    let(:categories) { create_list(:category, 5) }

    before do
      categories
      get_categories
    end

    it { expect(response).to have_http_status(:ok) }
    it { expect(json).not_to be_empty }
    it { expect(json.size).to eq(5) }
  end

  describe 'POST /create' do
    subject(:post_category) { post api_v1_categories_path(category_params), headers: authenticated_header(user) }

    let!(:user) { create(:user) }
    let(:category_params) { { 'categories' => { 'name' => 'Test' } } }

    it { expect { post_category }.to change(Category, :count).by(1) }
  end

  describe 'GET /show' do
    let(:category) { create(:category) }

    before do
      category
      get api_v1_category_path(category.id)
    end

    it { expect(json['id'].to_i).to eq(category.id) }
  end
end
