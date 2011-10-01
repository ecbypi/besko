require 'spec_helper'
require 'cancan/matchers'

describe Ability do

  describe "as a resident" do
    let(:user) { Factory(:user) }
    let(:ability) { Ability.new(user) }
    let(:package) { Factory(:package, :recipient => user) }

    it "can see and sign out their own packages" do
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
    let(:worker) { Factory(:besk_worker) }
    let(:ability) { Ability.new(worker) }

    it "can review and create packages" do
      ability.should be_able_to(:create, :packages)
      ability.should be_able_to(:review, :packages)
    end
  end
end
