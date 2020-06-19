require 'spec_helper'

RSpec.describe UsersController do
  include Devise::Test::ControllerHelpers

  describe "GET index.json" do
    before do
      sign_in create(:user, :desk_worker)
    end

    it 'only allows desk workers' do
      sign_in create(:user, email: 'guy@fake-email.com')

      get :index, params: { format: :json, term: 'guy' }

      expect(response.status).to eq 401
    end

    it "searches database and MIT directory if no options are specified" do
      expect(User).to receive(:search).with('micro helpline').and_return([])
      expect(User).to receive(:directory_search).with('micro helpline').and_return([])

      get :index, params: { format: :json, term: 'micro helpline' }
    end

    it "only searches the database if :local_only param is true" do
      expect(User).to receive(:search).with('micro helpline').and_return([])
      expect(User).not_to receive(:directory_search)

      get :index, params: { format: :json, term: 'micro helpline', options: { local_only: true } }
    end

    it "only searches the MIT directory if :directory_only param is true" do
      expect(User).to receive(:directory_search).with('micro helpline').and_return([])
      expect(User).not_to receive(:search)

      get :index, params: { format: :json, term: 'micro helpline', options: { directory_only: true } }
    end

    it "returns unique results based on email" do
      create(:user, email: 'mrhalp@mit.edu')
      stub_ldap! # Stubs LDAP with mrhalp user

      get :index, params: { format: :json, term: 'micro helpline' }

      users = JSON.parse(response.body)
      expect(users.size).to eq 1
    end
  end

  describe "POST create.json" do
    it "only allows desk workers" do
      sign_in create(:user, :desk_worker)

      expect do
        post :create, params: { format: :json, user: attributes_for(:user) }
      end.to change { User.count }
    end

    it 'denies anyone else' do
      sign_in create(:user)

      expect do
        post :create, params: { format: :json, user: attributes_for(:user) }
      end.not_to change { User.count }

      expect(response.status).to eq 401
    end
  end
end
