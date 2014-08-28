require 'spec_helper'

describe DeliveriesController do
  include Devise::TestHelpers

  describe 'DELETE destroy' do
    it 'denies anyone not logged in' do
      delivery = create(:delivery)

      delete :destroy, id: delivery.id

      expect(Delivery.exists?(delivery.id)).to be true
    end

    it 'denies regular users' do
      delivery = create(:delivery)

      sign_in create(:user)

      delete :destroy, id: delivery.id

      expect(Delivery.exists?(delivery.id)).to be true
    end

    it 'denies besk workers' do
      delivery = create(:delivery)

      sign_in create(:user, :desk_worker)

      delete :destroy, id: delivery.id

      expect(Delivery.exists?(delivery.id)).to be true
    end

    it 'allows admins' do
      delivery = create(:delivery)

      sign_in create(:user, :admin)

      delete :destroy, id: delivery.id

      expect(Delivery.exists?(delivery.id)).to be false
    end
  end
end
