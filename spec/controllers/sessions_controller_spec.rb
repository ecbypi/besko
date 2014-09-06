require "spec_helper"

RSpec.describe SessionsController do
  include Devise::TestHelpers

  before do
    request.env['devise.mapping'] = Devise.mappings[:user]
  end

  describe "GET new" do
    it "signs in user if REMOTE_USER request env variable is present and redirects to receipts page" do
      create(:user, email: "funguy@school.edu")
      request.env["REMOTE_USER"] = "funguy@school.edu"

      get :new

      expect(response.status).to eq 302
      expect(response.location).to eq receipts_url
      expect(session['warden.user.user.key']).not_to be_nil
      expect(session['warden.user.user.session']).not_to be_nil
    end

    it "continues normally if REMOTE_USER request env variable is missing" do
      get :new

      expect(response.status).to eq 200
      expect(session['warden.user.user.key']).to be_nil
      expect(session['warden.user.user.session']).to be_nil
    end

    it "continues normally if user does not exist locally" do
      request.env["REMOTE_USER"] = "funguy@school.edu"

      get :new

      expect(response.status).to eq 200
      expect(session['warden.user.user.key']).to be_nil
      expect(session['warden.user.user.session']).to be_nil
    end
  end

  describe "DELETE destroy" do
    it "redirects to delete Shibboleth logout handler" do
      return_url = CGI.escape(root_url)

      delete :destroy

      expect(response.status).to eq 302
      expect(response.location).to eq "https://testshib.org/Shibboleth.sso/Logout?return=#{return_url}"
    end
  end
end
