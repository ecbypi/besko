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

      expect(session['warden.user.user.key']).not_to be_nil
      expect(session['warden.user.user.session']).not_to be_nil
    end
  end
end
