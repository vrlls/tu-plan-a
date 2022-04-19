# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users', type: :request do
  describe 'GET /index' do
    subject(:get_users) { get api_v1_users_path }

    let(:users) { create_list(:user, 5) }

    before do
      users
      get_users
    end

    it { expect(response).to have_http_status(:ok) }
    it { expect(json['data']).not_to be_empty }
    it { expect(json['data'].size).to eq(5) }
  end

  describe 'POST /create' do
    subject(:post_user) { post api_v1_users_path(user_params) }

    let(:user_params) { { 'username' => 'Test', 'email' => 'test@email.com', 'password' => '123456' } }

    it { expect { post_user }.to change(User, :count).by(1) }
  end

  describe 'GET /show' do
    let(:user) { create(:user) }

    before do
      user
      get api_v1_user_path(user.id)
    end

    it { expect(json['data']['id'].to_i).to eq(user.id) }
  end

  describe 'DELETE /destroy' do
    let(:user) { create(:user) }

    before do
      user
      delete api_v1_user_path(user.id)
    end

    it { expect(response).to have_http_status(:no_content) }
  end

  describe 'PUT /update' do
    let(:user) { create(:user) }
    let(:user_params) { { 'username' => 'New name' } }

    before do
      user
      put api_v1_user_path(user.id, user_params)
    end

    it { expect(response).to have_http_status(:ok) }
    it { expect(json['data']['attributes']['username']).to eq('New name') }
  end
end
