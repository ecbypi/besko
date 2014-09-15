require "spec_helper"

RSpec.describe DeskWorkerSynchronizationWorker do
  it "assigns users in the specified AFS group the `DeskWorker` role" do
    stub_pts_membership_command! "drhalp"
    create(:user, login: "drhalp")

    DeskWorkerSynchronizationWorker.perform_async

    worker_logins = User.desk_workers.pluck(:login)
    expect(worker_logins).to eq ["drhalp"]
  end

  it "removes the `DeskWorker` role from users not in the AFS group" do
    stub_pts_membership_command! "mrhalp"
    create(:user, :desk_worker, login: "drhalp")
    create(:user, login: "mrhalp")

    DeskWorkerSynchronizationWorker.perform_async

    worker_logins = User.desk_workers.pluck(:login)
    expect(worker_logins).to eq ["mrhalp"]
  end

  it "creates users in the command output but not in the local database" do
    stub_pts_membership_command! "mshalp"
    stub_ldap! uid: "mshalp"

    DeskWorkerSynchronizationWorker.perform_async

    user = User.find_by!(login: "mshalp")
    expect(user).to be_a_desk_worker
    expect(user).to be_confirmed
    expect(user).to be_activated
  end

  it "notifies Honeybadger if ENV['DESK_WORKERS_GROUP'] variable is missing" do
    group, ENV["DESK_WORKERS_GROUP"] = ENV["DESK_WORKERS_GROUP"], nil

    stub_pts_membership_command! "mrhalp"
    create(:user, login: "mrhalp")

    expect(Honeybadger).to receive(:notify)
    expect do
      DeskWorkerSynchronizationWorker.perform_async
    end.not_to change { UserRole.count }

    ENV["DESK_WORKERS_GROUP"] = group
  end

  it "notifies Honeybadger if pts command is not successful" do
    allow_any_instance_of(PtsMembershipCommand).to receive_messages(
      command_output: "Not a valid response"
    )

    expect(Honeybadger).to receive(:notify)
    expect do
      DeskWorkerSynchronizationWorker.perform_async
    end.not_to change { UserRole.count }
  end

  it "notifies Honeybadger if user is not found in LDAP" do
    stub_pts_membership_command! "mrhalp"
    allow_any_instance_of(DirectorySearch).to receive_messages(
      command_output: ""
    )

    expect(Honeybadger).to receive(:notify)
    expect do
      DeskWorkerSynchronizationWorker.perform_async
    end.not_to change { UserRole.count }
  end
end
