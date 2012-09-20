require 'spec_helper'

describe UserRole do
  it { should belong_to(:user) }

  it "validates uniqueness of :title per user" do
    create(:user_role)
    should validate_uniqueness_of(:title).scoped_to(:user_id)
  end

  describe ".with_title" do
    let!(:besk_worker) { create(:user_role) }
    let!(:admin) { create(:user_role, title: 'Admin') }

    it "selects role objects in reverse order of creation" do
      roles = UserRole.with_title(:BeskWorker)

      roles.should include besk_worker
      roles.should_not include admin
    end
  end
end
