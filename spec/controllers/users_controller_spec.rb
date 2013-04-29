require 'spec_helper'

describe UsersController do
  include Devise::TestHelpers

  def json_body
    @json_body ||= JSON.parse(response.body)
  end

  def users
    json_body['users']
  end

  describe "GET index.json" do
    let(:user) { create(:user) }

    before :each do
      sign_in user
      stub_ldap_server_configuration!
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

      users.size.should eq 1
    end
  end

  describe "POST create.json" do
    let(:attributes) do
      {
        first_name: 'Doctor',
        last_name: 'Halp',
        login: 'drhalp',
        email: 'drhalp@mit.edu'
      }
    end

    it "returns the persisted user information" do
      post :create, format: :json, user: attributes

      json_body.should have_key 'user'
      json_body['user'].should have_key 'id'
    end
  end
end
