require 'spec_helper'

describe Role do
  let!(:role) { create(:role) }

  it { should validate_uniqueness_of(:title).case_insensitive }
  it { should have_many(:user_roles) }
  it { should have_many(:users).through(:user_roles) }
end
