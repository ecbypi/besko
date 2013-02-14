class DirectorySearch

  attr_reader :query, :filter, :results, :options

  def self.search(query, options = {})
    new(query, options).search
  end

  def initialize(query, options = {})
    @query = query
    @options = options.dup

    @options.reverse_merge!(
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
    arguments = query.split

    @filter = if arguments.size > 1
      Ldaptic::Filter(cn: "#{arguments.join('*')}*", :* => true) |
        Ldaptic::Filter(sn: arguments.last + '*', :* => true) |
        Ldaptic::Filter(mail: arguments) |
        Ldaptic::Filter(uid: arguments)
    else
      value = arguments.pop
      Ldaptic::Filter(uid: value) |
        Ldaptic::Filter(mail: value) |
        Ldaptic::Filter(givenName: value) |
        Ldaptic::Filter(givenName: value) |
        Ldaptic::Filter(sn: "#{value}*", :* => true)
    end
  end
end
