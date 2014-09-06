require "spec_helper"

RSpec.describe ShibbolethSessionsController do
  describe "POST create" do
    context "when ENV['SHIBBOLETH_LOGIN_HANDLER'] is set" do
      it "redirects to the login handler with a redirect param to login page" do
        target_url = CGI.escape(new_user_session_url)

        post :create

        expect(response.status).to eq 302
        expect(response.location).to eq "https://testshib.org/Shibboleth.sso/Login?target=#{target_url}"
      end
    end

    context "when ENV['SHIBBOLETH_LOGIN_HANDLER'] is not set" do
      it "redirects to login page" do
        login_handler = ENV.delete("SHIBBOLETH_LOGIN_HANDLER")

        post :create

        expect(response.status).to eq 302
        expect(response.location).to eq new_user_session_url

        ENV["SHIBBOLETH_LOGIN_HANDLER"] = login_handler
      end
    end
  end
end
