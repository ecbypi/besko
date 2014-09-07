class PtsMembershipCommand
  # `pts` has a 0 exit status with these failures
  SUCCESS_MESSAGE_REGEX = /Members of system:\w+ \(id: -\w+\) are:/

  attr_reader :group_name, :command_output

  def initialize(group_name)
    @group_name = group_name
  end

  def group_members
    @members ||=
      if successful?
        parse_output(command_output)
      else
        []
      end
  end

  def successful?
    !(command_output =~ SUCCESS_MESSAGE_REGEX).nil?
  end

  def command_output
    @command_output ||= begin
      command.run(group_name: group_name)
    rescue Cocaine::ExitStatusError
      ""
    end
  end

  private

  def command
    @command ||= Cocaine::CommandLine.new(
      "pts",
      "membership -noauth system::group_name",
      logger: Rails.logger
    )
  end

  def parse_output(output)
    command_output.split(/\n/)[1..-1].map { |login| login.strip }
  end
end
