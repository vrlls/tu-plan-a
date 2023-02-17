# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserManager::RoleSetter, type: :service do
  describe 'call' do
    subject(:set_role) { described_class.call(user.id, roles) }

    let!(:user) { create(:user) }
    let(:roles) { %w[admin editor] }

    before do
      set_role
    end

    it { expect(User.last.roles.pluck(:name)).to include('admin', 'editor') }
  end
end
