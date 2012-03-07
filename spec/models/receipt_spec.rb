require 'spec_helper'

describe Receipt do

  it { should belong_to(:recipient) }
  it { should belong_to(:delivery) }
  it { should have_many(:packages) }
end
