require 'spec_helper'

RSpec.describe DeliveriesController do
  include Devise::Test::ControllerHelpers

  describe 'DELETE destroy' do
    it 'denies anyone not logged in' do
      delivery = create(:delivery)

      delete :destroy, params: { id: delivery.id }

      expect(Delivery.exists?(delivery.id)).to be true
    end

    it 'denies regular users' do
      delivery = create(:delivery)

      sign_in create(:user)

      delete :destroy, params: { id: delivery.id }

      expect(Delivery.exists?(delivery.id)).to be true
    end

    it 'denies besk workers' do
      delivery = create(:delivery)

      sign_in create(:user, :desk_worker)

      delete :destroy, params: { id: delivery.id }

      expect(Delivery.exists?(delivery.id)).to be true
    end

    it 'allows admins' do
      delivery = create(:delivery)

      sign_in create(:user, :admin)

      delete :destroy, params: { id: delivery.id }

      expect(Delivery.exists?(delivery.id)).to be false
    end
  end
end
