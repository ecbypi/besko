require 'spec_helper'
require 'cancan/matchers'

describe Ability do
  describe "as a normal user" do
    it "can see and sign out only their own packages" do
      user = create(:user)
      ability = Ability.new(user)
      package = create(:receipt, user: user)

      ability.should be_able_to(:read, package)
      ability.should_not be_able_to(:update, package)

      package = create(:receipt)

      ability.should_not be_able_to(:read, package)
    end
  end

  describe "as a worker" do
    it "can review and create packages and create and search users" do
      worker = create(:user, :desk_worker)
      ability = Ability.new(worker)

      ability.should be_able_to(:read, Delivery)
      ability.should be_able_to(:create, Delivery)
      ability.should_not be_able_to(:destroy, Delivery)

      ability.should be_able_to(:index, User)
      ability.should be_able_to(:create, User)

      ability.should be_able_to(:update, Receipt)
    end
  end

  describe "as a admin" do
    it 'can review and delete deliveries' do
      admin = create(:user, :admin)
      ability = Ability.new(admin)

      ability.should be_able_to(:read, Delivery)
      ability.should be_able_to(:destroy, Delivery)
    end
  end
end
