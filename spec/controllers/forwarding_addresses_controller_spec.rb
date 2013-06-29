require 'spec_helper'

describe ForwardingAddressesController do
  include Devise::TestHelpers

  it 'requires a logged in user to edit addresses' do
    attributes = attributes_for(:forwarding_address)

    post :create, forwarding_address: attributes
    response.headers['Location'].should include new_user_session_path

    post :update, forwarding_address: attributes
    response.headers['Location'].should include new_user_session_path

    sign_in create(:user)

    post :create, forwarding_address: attributes
    response.headers['Location'].should include edit_user_registration_path

    post :update, forwarding_address: attributes
    response.headers['Location'].should include edit_user_registration_path
  end

  describe 'GET index.json' do
    it 'denies users without mail forwarding permissions' do
      get :index, format: :json, q: 'chief'
      response.status.should eq 401

      user = create(:user)
      sign_in user

      get :index, format: :json, q: 'chief'
      response.status.should eq 406
    end

    it 'allows users with mail forwarding bits' do
      sign_in create(:user, :mail_forwarder)

      get :index, format: :json, q: 'derp'
      response.status.should eq 200
    end
  end
end
