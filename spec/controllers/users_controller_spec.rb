require 'spec_helper'

describe UsersController do
  include Devise::TestHelpers

  def json_body
    @json_body ||= JSON.parse(response.body)
  end

  describe "GET index.json" do
    let(:user) { FactoryGirl.create(:user) }
    let!(:result) { FactoryGirl.create(:mrhalp) }
    let(:role) { FactoryGirl.create(:role, title: 'Besk Worker') }

    before :each do
      user.roles << role
      sign_in user
      User.stub(:recipients).and_return([result])
      get :index, format: :json, term: 'micro helpline'
    end

    it "is successful" do
      response.should be_success
    end

    it "includes the #to_json versions of the users" do
      user = json_body.first
      user.should have_key 'first_name'
      user.should have_key 'last_name'
      user.should have_key 'login'
      user.should have_key 'email'
      user.should have_key 'id'
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

    let(:user) { FactoryGirl.create(:user, attributes) }

    before :each do
      User.stub(:create_with_or_without_password).and_return(user)
      post :create, format: :json, user: attributes
    end

    it "returns the persisted user information" do
      json_body.should have_key 'id'
    end
  end
end
