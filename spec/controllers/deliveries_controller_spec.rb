require 'spec_helper'

describe DeliveriesController do
  include Devise::TestHelpers

  describe 'DELETE destroy' do
    it 'denies anyone not logged in' do
      delivery = create(:delivery)

      delete :destroy, id: delivery.id

      Delivery.exists?(delivery.id).should be_true
    end

    it 'denies regular users' do
      delivery = create(:delivery)

      sign_in create(:user)

      delete :destroy, id: delivery.id

      Delivery.exists?(delivery.id).should be_true
    end

    it 'denies besk workers' do
      delivery = create(:delivery)

      sign_in create(:user, :besk_worker)

      delete :destroy, id: delivery.id

      Delivery.exists?(delivery.id).should be_true
    end

    it 'allows admins' do
      delivery = create(:delivery)

      sign_in create(:user, :admin)

      delete :destroy, id: delivery.id

      Delivery.exists?(delivery.id).should be_false
    end
  end
end
