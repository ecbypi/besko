require 'spec_helper'
require 'cancan/matchers'

describe Ability do

  describe "as a resident" do
    let(:user) { Factory(:user) }
    let(:ability) { Ability.new(user) }

    it "can see and sign out their own packages" do
      package = Factory(:package, recipient: user)
      ability.should be_able_to(:read, package)
      ability.should be_able_to(:update, package)
    end

    it "cannot see or sign out other users' packages" do
      package = Factory(:package)
      ability.should_not be_able_to(:read, package)
      ability.should_not be_able_to(:update, package)
    end
  end

  describe "as a worker" do
    let(:role) { Factory(:role, title: 'Besk Worker') }
    let(:worker) { Factory(:user) }
    let(:ability) { Ability.new(worker) }

    before :each do
      worker.roles << role
    end

    it "can review and create packages" do
      ability.should be_able_to(:create, :packages)
      ability.should be_able_to(:review, :packages)
    end
  end
end
