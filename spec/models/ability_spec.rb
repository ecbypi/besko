require 'spec_helper'
require 'cancan/matchers'

describe Ability do
  describe "as a normal user" do
    it "can see and sign out only their own packages" do
      user = create(:user)
      ability = Ability.new(user)
      package = create(:receipt, user: user)

      expect(ability).to be_able_to(:read, package)
      expect(ability).not_to be_able_to(:update, package)

      package = create(:receipt)

      expect(ability).not_to be_able_to(:read, package)
    end
  end

  describe "as a worker" do
    it "can review and create packages and create and search users" do
      worker = create(:user, :desk_worker)
      ability = Ability.new(worker)

      expect(ability).to be_able_to(:read, Delivery)
      expect(ability).to be_able_to(:create, Delivery)
      expect(ability).not_to be_able_to(:destroy, Delivery)

      expect(ability).to be_able_to(:index, User)
      expect(ability).to be_able_to(:create, User)

      expect(ability).to be_able_to(:update, Receipt)
    end
  end

  describe "as a admin" do
    it 'can review and delete deliveries' do
      admin = create(:user, :admin)
      ability = Ability.new(admin)

      expect(ability).to be_able_to(:read, Delivery)
      expect(ability).to be_able_to(:destroy, Delivery)
    end
  end
end
