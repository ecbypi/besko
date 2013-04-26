require 'spec_helper'

describe PreviousAddress do
  it { should belong_to(:user) }
  it { should belong_to(:preceded_by) }
  it { should have_one(:followed_by) }
end
