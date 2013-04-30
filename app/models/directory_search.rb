class DirectorySearch
  attr_reader :query, :results

  def self.search(query)
    new(query).search
  end

  def self.server
    ENV['LDAP_SERVER']
  end

  def initialize(query)
    @query = query
  end

  def search
    return @results      unless results.nil?
    return @results = [] unless server.present?

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

  def server
    self.class.server
  end

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
        command.run(filter: filter.to_s, server: server)
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
    "directory_search.#{query.gsub(/\s+/,'_')}"
  end
end
