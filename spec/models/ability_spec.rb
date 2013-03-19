require 'spec_helper'
require 'cancan/matchers'

describe Ability do
  describe "as a resident" do
    let(:user) { create(:user) }
    let(:ability) { Ability.new(user) }

    it "can see and sign out their own packages" do
      package = create(:receipt, recipient: user)
      ability.should be_able_to(:read, package)
      ability.should be_able_to(:update, package)
    end

    it "cannot see or sign out other users' packages" do
      package = create(:receipt)
      ability.should_not be_able_to(:read, package)
      ability.should_not be_able_to(:update, package)
    end
  end

  describe "as a worker" do
    let(:worker) { create(:user, :besk_worker) }
    let(:ability) { Ability.new(worker) }

    it "can review and create packages" do
      ability.should be_able_to(:create, Delivery)
      ability.should be_able_to(:read, Delivery)
    end
  end

  describe "as a admin" do
    let(:admin) { create(:user, :admin) }
    let(:ability) { Ability.new(admin) }

    it "can manage user roles" do
      ability.should be_able_to(:manage, UserRole)
    end
  end
end
