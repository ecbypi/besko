require 'spec_helper'

RSpec.describe UsersController do
  include Devise::TestHelpers

  describe "GET index.json" do
    before do
      sign_in create(:user, :desk_worker)
    end

    it 'only allows desk workers' do
      sign_in create(:user, email: 'guy@fake-email.com')

      get :index, format: :json, term: 'guy'

      expect(response.status).to eq 401
    end

    it "searches database and MIT directory if no options are specified" do
      expect(User).to receive(:search).with('micro helpline').and_return([])
      expect(User).to receive(:directory_search).with('micro helpline').and_return([])

      get :index, format: :json, term: 'micro helpline'
    end

    it "only searches the database if :local_only param is true" do
      expect(User).to receive(:search).with('micro helpline').and_return([])
      expect(User).not_to receive(:directory_search)

      get :index, format: :json, term: 'micro helpline', options: { local_only: true }
    end

    it "only searches the MIT directory if :directory_only param is true" do
      expect(User).to receive(:directory_search).with('micro helpline').and_return([])
      expect(User).not_to receive(:search)

      get :index, format: :json, term: 'micro helpline', options: { directory_only: true }
    end

    it "returns unique results based on email" do
      create(:user, email: 'mrhalp@mit.edu')
      stub_ldap! # Stubs LDAP with mrhalp user

      get :index, format: :json, term: 'micro helpline'

      users = JSON.parse(response.body)
      expect(users.size).to eq 1
    end

    context 'when `category` param is present' do
      before do
        create(:user, :desk_worker, first_name: 'Ron', last_name: 'Howard')
        create(:user, first_name: 'Ron', last_name: 'Burgundy') do |user|
          create(:receipt, user: user)
        end
      end

      it 'filters for desk workers when param is "desk_worker"' do
        get :index, format: :json, term: 'Ron', category: 'desk_worker'
        users = JSON.parse(response.body)

        expect(users.size).to eq 1
        expect(users.first['last_name']).to eq 'Howard'
      end

      it 'filters for users with any packages when param is "recipient"' do
        get :index, format: :json, term: 'Ron', category: 'recipient'
        users = JSON.parse(response.body)

        expect(users.size).to eq 1
        expect(users.first['last_name']).to eq 'Burgundy'
      end
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

      expect(response.status).to eq 401
    end
  end
end
