class DirectorySearch

  attr_reader :query, :filter, :results, :options

  def self.search(query, options = {})
    new(query, options).search
  end

  def initialize(query, options = {})
    @query = query
    @options = options.dup

    @options.reverse_merge!(
      size: 20,
      instantiate: false
    )

    @options[:filter] = construct_filter.to_s

    @options.freeze
  end

  def search
    @results = MIT::LDAP.connect! ? MIT::LDAP.search(options) : []

  rescue Ldaptic::ServerError
    @results = []

  ensure
    return self
  end

  private

  def construct_filter
    filter = {}
    arguments = query.split

    if arguments.size > 1
      filter[:cn] = arguments.join('*') + '*'
      filter[:sn] = arguments.last + '*'
      filter[:mail] = filter[:uid] = arguments
    else
      filter[:uid] = filter[:mail] = arguments.first
      filter[:givenName] = arguments.first
      filter[:sn] = arguments.first + '*'
    end

    @filter = LDAP::Filter::OrFilter.new(filter)
  end
end
