require 'spec_helper'
require 'cancan/matchers'

describe Ability do
  describe "as a normal user" do
    it "can see and sign out only their own packages" do
      user = create(:user)
      ability = Ability.new(user)
      package = create(:receipt, user: user)

      expect(ability.can?(:read, package)).to eq true
      expect(ability.can?(:update, package)).to eq false

      package = create(:receipt)

      expect(ability.can?(:read, package)).to eq false
    end
  end

  describe "as a worker" do
    it "can review and create packages and create and search users" do
      worker = create(:user, :desk_worker)
      ability = Ability.new(worker)

      expect(ability.can?(:read, Delivery)).to eq true
      expect(ability.can?(:create, Delivery)).to eq true
      expect(ability.can?(:destroy, Delivery)).to eq false

      expect(ability.can?(:index, User)).to eq true
      expect(ability.can?(:create, User)).to eq true

      expect(ability.can?(:update, Receipt)).to eq true
    end
  end

  describe "as a admin" do
    it 'can review and delete deliveries' do
      admin = create(:user, :admin)
      ability = Ability.new(admin)

      expect(ability.can?(:read, Delivery)).to eq true
      expect(ability.can?(:destroy, Delivery)).to eq true
    end
  end
end
