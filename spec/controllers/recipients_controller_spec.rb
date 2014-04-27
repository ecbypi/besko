require 'spec_helper'

describe RecipientsController do
  include Devise::TestHelpers

  describe 'POST create.json' do
    let(:attributes) do
      attributes_for(:user, password: nil, password_confirmation: nil)
    end

    it 'denies anyone not logged in' do
      post :create, format: :json, recipient: attributes

      response.should_not be_successful
      response.status.should eq 406
    end

    it 'denies regular users' do
      delivery = create(:delivery)

      sign_in create(:user)

      post :create, format: :json, recipient: attributes

      response.should_not be_successful
      response.status.should eq 406
    end

    it 'allows besk workers' do
      delivery = create(:delivery)

      sign_in create(:user, :desk_worker)

      post :create, format: :json, recipient: attributes

      response.should be_successful
    end

    it 'denies admins' do
      delivery = create(:delivery)

      sign_in create(:user, :admin)

      post :create, format: :json, recipient: attributes

      response.should_not be_successful
      response.status.should eq 406
    end
  end
end
