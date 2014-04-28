class DirectorySearch
  attr_reader :query

  def self.search(query)
    new(query).results
  end

  def initialize(query)
    @query = query
  end

  def results
    @results ||= begin
      if ENV.key?('LDAP_SERVER')
        Timeout.timeout(2) do
          parse_output(command_output)
        end
      else
        []
      end
    rescue Timeout::Error
      []
    end
  end

  def filter
    @filter ||= begin
      terms = query.split

      if terms.size > 1
        filter = Ldaptic::Filter(cn: "#{terms.join('*')}*", :* => true)
        filter = filter | Ldaptic::Filter(sn: terms.last + '*', :* => true)
        filter = filter | Ldaptic::Filter(mail: terms)
        filter | Ldaptic::Filter(uid: terms)
      else
        value = terms.pop

        filter = Ldaptic::Filter(uid: value)
        filter = filter | Ldaptic::Filter(mail: value)
        filter = filter | Ldaptic::Filter(givenName: value)
        filter = filter | Ldaptic::Filter(givenName: value)
        filter | Ldaptic::Filter(sn: "#{value}*", :* => true)
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
    Rails.cache.fetch(cache_key, expires_in: 1.month) do
      begin
        command.run(filter: filter.to_s, server: ENV['LDAP_SERVER'])
      rescue Cocaine::ExitStatusError
        ''
      end
    end
  end

  def command_options
    '-x -LLL -h :server -b dc=mit,dc=edu :filter'
  end

  def parse_output(output)
    output.gsub(/\n (\w)/, '\1').split(/\n\n/).map do |record|
      Hash[record.split(/\n/).map { |line| line.split(/: /) }]
    end
  end

  def cache_key
    "directory_search.#{query.parameterize}"
  end
end
