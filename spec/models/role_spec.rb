require 'spec_helper'

describe Role do
  let!(:role) { create(:role) }

  it { should have_many(:user_roles) }
  it { should have_many(:users).through(:user_roles) }
end
