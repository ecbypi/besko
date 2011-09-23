require 'spec_helper'

describe ApplicationController do
  let(:user) { Factory(:user) }

  describe "#current_user" do
    it "returns logged in user" do
      UserSession.stub(:create, user).and_return(mock('UserSession', :user => user))
      controller.should_receive(:current_user).and_return(user)
      controller.current_user
    end

    it "returns nil if no user is logged in" do
      controller.should_receive(:current_user).and_return(nil)
      controller.current_user
    end
  end
end
