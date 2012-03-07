require 'spec_helper'

describe Delivery do

  it { should belong_to(:worker) }
  it { should have_many(:receipts) }

  it { should validate_presence_of(:deliverer) }
end
