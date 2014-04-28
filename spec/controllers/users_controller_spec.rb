require 'spec_helper'

describe UsersController do
  include Devise::TestHelpers

  describe "GET index.json" do
    before do
      sign_in create(:user, :desk_worker)
    end

    it 'only allows desk workers' do
      sign_in create(:user, email: 'guy@fake-email.com')

      get :index, format: :json, term: 'guy'

      response.status.should eq 401
    end

    it "searches database and MIT directory if no options are specified" do
      User.should_receive(:search).with('micro helpline').and_return([])
      User.should_receive(:directory_search).with('micro helpline').and_return([])

      get :index, format: :json, term: 'micro helpline'
    end

    it "only searches the database if :local_only param is true" do
      User.should_receive(:search).with('micro helpline').and_return([])
      User.should_not_receive(:directory_search)

      get :index, format: :json, term: 'micro helpline', options: { local_only: true }
    end

    it "only searches the MIT directory if :directory_only param is true" do
      User.should_receive(:directory_search).with('micro helpline').and_return([])
      User.should_not_receive(:search)

      get :index, format: :json, term: 'micro helpline', options: { directory_only: true }
    end

    it "returns unique results based on email" do
      create(:user, email: 'mrhalp@mit.edu')
      stub_ldap! # Stubs LDAP with mrhalp user

      get :index, format: :json, term: 'micro helpline'

      users = JSON.parse(response.body)
      users.size.should eq 1
    end
  end

  describe "POST create.json" do
    it "only allows desk workers" do
      sign_in create(:user, :desk_worker)

      expect { post :create, format: :json, user: attributes_for(:user) }.to change { User.count }
    end

    it 'denies anyone else' do
      sign_in create(:user)

      expect { post :create, format: :json, user: attributes_for(:user) }.not_to change { User.count }

      response.status.should eq 401
    end
  end
end
