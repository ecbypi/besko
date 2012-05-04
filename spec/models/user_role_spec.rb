require 'spec_helper'

describe UserRole do
  it { should belong_to(:user) }

  it do
    create(:user_role)
    should validate_uniqueness_of(:user_id).scoped_to(:title)
  end
end
