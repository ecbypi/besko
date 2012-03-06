require 'spec_helper'

describe UsersController do
  include Devise::TestHelpers

  describe "GET index.json" do
    let(:user) { FactoryGirl.create(:user) }
    let!(:result) { FactoryGirl.create(:mrhalp) }
    let(:role) { FactoryGirl.create(:role, title: 'Besk Worker') }

    def json_body
      @json_body ||= JSON.parse(response.body)
    end

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
      json_body.size.should eq 1
      json_body.should eq [{'first_name' => 'Micro', 'last_name' => 'Helpline', 'login' => 'mrhalp', 'email' => 'mrhalp@mit.edu'}]
    end
  end
end
