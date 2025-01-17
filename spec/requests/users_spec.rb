# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users' do
  def authenticated_header(user)
    token = Knock::AuthToken.new(payload: { sub: user.id }).token
    { Authorization: "Bearer #{token}" }
  end

  describe 'GET /index' do
    subject(:get_users) { get api_v1_users_path, headers: authenticated_header(user) }

    let(:user) { create(:admin) }
    let(:users) { create_list(:user, 5) }

    before do
      users
      get_users
    end

    it { expect(response).to have_http_status(:ok) }
    it { expect(json).not_to be_empty }
    it { expect(json.size).to eq(6) }
  end

  describe 'POST /create' do
    subject(:post_user) { post api_signup_path(user_params) }

    let(:user_params) { { 'user' => { 'name' => 'Testname', 'username' => 'Test', 'email' => 'test@email.com', 'password' => '123456', 'roles' => ['admin'] } } }

    it { expect { post_user }.to change(User, :count).by(1) }

    it 'user has role admin' do
      post_user
      expect(User.last.roles.last.name).to eq('admin')
    end
  end

  describe 'GET /show' do
    let(:user) { create(:user) }

    before do
      user
      get api_v1_user_path(user.id), headers: authenticated_header(user)
    end

    it { expect(json['id'].to_i).to eq(user.id) }
  end

  describe 'PUT /update' do
    let(:user) { create(:user) }
    let(:user_params) { { 'user' => { 'username' => 'New name' } } }

    before do
      user
      put api_v1_user_path(user.id, user_params), headers: authenticated_header(user)
    end

    it { expect(response).to have_http_status(:ok) }
    it { expect(json['username']).to eq('New name') }
  end
end
