require 'spec_helper'

describe UserRole do
  it { should belong_to(:user) }

  it { should validate_uniqueness_of(:title).scoped_to(:user_id) }
  it { should validate_presence_of(:user) }
end
