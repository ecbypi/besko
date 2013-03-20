class DirectorySearch
  attr_reader :query, :results

  def self.search(query)
    new(query).search
  end

  def initialize(query)
    @query = query
  end

  def search
    return self unless results.nil?

    @results = Timeout.timeout(2) do
      parse_output(command_output)
    end
  rescue Timeout::Error
    @results = []
  end

  def filter
    @filter ||= begin
      terms = query.split

      if terms.size > 1
        Ldaptic::Filter(cn: "#{terms.join('*')}*", :* => true) |
          Ldaptic::Filter(sn: terms.last + '*', :* => true) |
          Ldaptic::Filter(mail: terms) |
          Ldaptic::Filter(uid: terms)
      else
        value = terms.pop
        Ldaptic::Filter(uid: value) |
          Ldaptic::Filter(mail: value) |
          Ldaptic::Filter(givenName: value) |
          Ldaptic::Filter(givenName: value) |
          Ldaptic::Filter(sn: "#{value}*", :* => true)
      end
    end
  end

  private

  def command
    @command ||= Cocaine::CommandLine.new(
      'ldapsearch',
      command_options,
      expected_outcodes: [0, 4, 11],
      logger: Rails.logger
    )
  end

  def command_output
    command.run(filter: filter.to_s)
  rescue Cocaine::ExitStatusError
    ''
  end

  def command_options
    '-x -LLL -h ldap-too.mit.edu -b dc=mit,dc=edu :filter uid givenName sn mail street'
  end

  def parse_output(output)
    output.gsub(/\n (\w)/, '\1').split(/\n\n/).map do |record|
      Hash[record.split(/\n/).map { |line| line.split(/: /) }]
    end
  end
end
