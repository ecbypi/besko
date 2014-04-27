require 'spec_helper'

describe UserRole do
  it { should belong_to(:user) }

  it "validates uniqueness of :title per user" do
    create(:user_role)
    should validate_uniqueness_of(:title).scoped_to(:user_id)
  end
  it { should validate_presence_of(:user_id) }

  describe ".with_title" do
    let!(:desk_worker) { create(:user_role, title: 'DeskWorker') }
    let!(:admin) { create(:user_role, title: 'Admin') }

    it "selects role objects in reverse order of creation" do
      roles = UserRole.with_title(:DeskWorker)

      roles.should include desk_worker
      roles.should_not include admin
    end
  end
end
