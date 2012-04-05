require 'spec_helper'
require 'cancan/matchers'

describe Ability do

  before :each do
    double_roles :BeskWorker
  end

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
    let(:role) { create(:role) }
    let(:worker) { create(:user) }
    let(:ability) { Ability.new(worker) }

    before :each do
      stub_user_roles(worker, :besk_worker)
    end

    it "can review and create packages" do
      ability.should be_able_to(:create, Delivery)
      ability.should be_able_to(:read, Delivery)
    end
  end
end
