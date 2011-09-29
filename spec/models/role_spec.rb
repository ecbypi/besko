require 'spec_helper'

describe Role do
  let!(:role) { Factory(:role) }

  it { should have_and_belong_to_many(:users) }
  it { should validate_uniqueness_of(:title).case_insensitive }
end
