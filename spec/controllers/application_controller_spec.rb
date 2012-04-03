require 'spec_helper'

describe ApplicationController do
  include Devise::TestHelpers

  describe "#touchstone_sign_in" do
    controller do
      def index
        render text: 'logged in'
      end
    end

    it "signs in user if 'REMOTE_USER' environment variable exists" do
      create(:mrhalp)

      request.env['REMOTE_USER'] = 'mrhalp@mit.edu'
      get :index

      session['warden.user.user.key'].should_not be_nil
      session['warden.user.user.session'].should_not be_nil
    end
  end
end
