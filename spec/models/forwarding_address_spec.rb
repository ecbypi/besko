require 'spec_helper'

RSpec.describe ForwardingAddress do
  it { should belong_to(:user) }

  it { should validate_presence_of(:street) }
  it { should validate_presence_of(:city) }
  it { should validate_presence_of(:state) }
  it { should validate_presence_of(:country) }
  it { should validate_presence_of(:postal_code) }
  it { should validate_presence_of(:user) }
end
