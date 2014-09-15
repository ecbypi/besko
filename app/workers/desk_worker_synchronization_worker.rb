class DeskWorkerSynchronizationWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence do
    minutes_of_hour = (0..59).select { |minute| minute % 5 == 0 }

    hourly.minute_of_hour(*minutes_of_hour)
  end

  def perform
    if group_name.blank?
      notify_of_failure("Missing group name")
    elsif !pts_command.successful?
      notify_of_failure("`pts` command unsuccessful")
    else
      remove_role_from_users_not_in_group

      group_members.each do |login|
        user = User.find_by(login: login)
        user ||= create_missing_user_from_directory(login)

        if user && !user.desk_worker?
          user.user_roles.create!(title: "DeskWorker")
        end
      end
    end
  end

  private

  def group_name
    ENV["DESK_WORKERS_GROUP"]
  end

  def pts_command
    @pts_command ||= PtsMembershipCommand.new(group_name)
  end

  def group_members
    pts_command.group_members
  end

  def remove_role_from_users_not_in_group
    UserRole.
      desk_workers.
      joins(:user).
      where.not(users: { login: group_members }).
      delete_all
  end

  def create_missing_user_from_directory(login)
    user = User.directory_search(login).first

    if user.nil?
      notify_of_failure("User '#{login}' not found in directory")
    else
      user.assign_password
      user.assign_attributes(
        confirmed_at: Time.zone.now,
        activated_at: Time.zone.now
      )
      user.save!

      user
    end
  end

  def notify_of_failure(failure_reason)
    Honeybadger.notify(
      error_class: RuntimeError,
      error_message: failure_reason,
      parameters: {
        desk_workers_group: group_name.inspect,
        pts_command_output: pts_command.command_output,
        path: ENV["PATH"]
      }
    )
  end
end
