require 'spec_helper'

describe UserRole do
  it { should belong_to(:user) }

  it "validates uniqueness of :title per user" do
    create(:user_role)
    should validate_uniqueness_of(:title).scoped_to(:user_id)
  end
end
