module MIT
  class << self
    def on_campus?
      ip_addresses.map { |ip| !(ip =~ /^18\./).nil? }.any?
    end

    def off_campus?
      !on_campus?
    end

    private

    def ip_addresses
      ifconfig.split(/\n/).grep(/inet (?:addr)?((?:\d{1,3}\.){3}\d{1,3})/) { $1 }
    end

    def ifconfig
      ifconfig_command.run
    end

    def ifconfig_command
      @ifconfig ||= Cocaine::CommandLine.new('ifconfig')
    end
  end
end
