require 'spec_helper'

describe Package do

  it { should belong_to(:worker) }
  it { should belong_to(:recipient) }
end
