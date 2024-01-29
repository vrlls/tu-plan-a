# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Events' do
  def authenticated_header(user)
    token = Knock::AuthToken.new(payload: { sub: user.id }).token
    { Authorization: "Bearer #{token}" }
  end

  describe 'GET /index' do
    subject(:get_events) { get api_v1_events_path }

    let(:events) { create_list(:event, 5) }

    before do
      events
      get_events
    end

    it { expect(response).to have_http_status(:ok) }
    it { expect(json).not_to be_empty }
    it { expect(json.size).to eq(5) }
  end

  describe 'POST /create' do
    subject(:post_event) { post api_v1_events_path(event_params), headers: authenticated_header(user) }

    let!(:user) { create(:editor) }
    let(:category) { create(:category) }
    let(:event_params) { { 'event' => { 'name' => 'Test', 'location' => '282 Kevin Brook, Imogeneborough, CA 58517', 'description' => 'Test description', 'category_id' => category, 'start_date' => '19-05-2022', 'end_date' => '20-05-2022' } } }

    it { expect { post_event }.to change(Event, :count).by(1) }

    it 'Role creator added' do
      post_event
      expect(user.roles.pluck(:name)).to be_truthy
    end
  end

  describe 'GET /show' do
    let(:event) { create(:event) }

    before do
      event
      get api_v1_event_path(event.id)
    end

    it { expect(json['id'].to_i).to eq(event.id) }
  end

  describe 'DELETE /destroy' do
    let(:event) { create(:event) }
    let!(:user) { create(:editor) }

    before do
      event
      delete api_v1_event_path(event.id), headers: authenticated_header(user)
    end

    it { expect(response).to have_http_status(:no_content) }
  end

  describe 'PUT /update' do
    let(:event) { create(:event) }
    let(:event_params) { { 'event' => { 'name' => 'New name' } } }
    let!(:user) { create(:editor) }

    before do
      event
      put api_v1_event_path(event.id, event_params), headers: authenticated_header(user)
    end

    it { expect(response).to have_http_status(:ok) }
    it { expect(json['name']).to eq('New name') }
  end

  describe 'PUT /activate' do
    subject(:activate) { put api_v1_event_activate_path(event), headers: authenticated_header(user) }

    let(:event) { create(:event) }
    let!(:user) { create(:editor) }


    before do
      activate
    end

    it { expect(Event.last).to be_active }
  end

  describe 'PUT /postpone' do
    subject(:postpone) { put api_v1_event_postpone_path(event), headers: authenticated_header(user) }

    let(:event) { create(:event) }
    let!(:user) { create(:editor) }


    before do
      postpone
    end

    it { expect(Event.last).to be_postponed }
  end

  describe 'PUT /cancel' do
    subject(:cancel) { put api_v1_event_cancel_path(event), headers: authenticated_header(user) }

    let(:event) { create(:event) }
    let!(:user) { create(:editor) }


    before do
      cancel
    end

    it { expect(Event.last).to be_canceled }
  end

  describe 'PUT /finish' do
    subject(:finish) { put api_v1_event_finish_path(event), headers: authenticated_header(user) }

    let(:event) { create(:event, status: 'active') }
    let!(:user) { create(:editor) }


    before do
      finish
    end

    it { expect(Event.last).to be_finished }
  end
end
