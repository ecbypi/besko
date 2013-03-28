require 'spec_helper'

describe DeliveriesController do
  include Devise::TestHelpers

  describe 'DELETE destroy.json' do
    it 'denies anyone not logged in' do
      delivery = create(:delivery)

      delete :destroy, format: :json, id: delivery.id

      response.should_not be_successful
      response.status.should eq 406
    end

    it 'denies regular users' do
      delivery = create(:delivery)

      sign_in create(:user)

      delete :destroy, format: :json, id: delivery.id

      response.should_not be_successful
      response.status.should eq 406
    end

    it 'denies besk workers' do
      delivery = create(:delivery)

      sign_in create(:user, :besk_worker)

      delete :destroy, format: :json, id: delivery.id

      response.should_not be_successful
      response.status.should eq 406
    end

    it 'allows admins' do
      delivery = create(:delivery)

      sign_in create(:user, :admin)

      delete :destroy, format: :json, id: delivery.id

      response.should be_successful
    end
  end
end
