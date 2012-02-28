module MIT
  module LDAP
    include Ldaptic::Module(host: 'ldap-too.mit.edu', base: 'dc=mit,dc=edu', adapter: :ldap_conn)

    def self.build_users search
      filter = build_filter(search)
      search(filter: filter.to_s).uniq.map(&:to_user)
    end

    def self.build_filter search
      arguments = search.split
      mail_key = search =~ /@mit\.edu/ ? :mail : :uid
      filters = []
      filters << ::LDAP::Filter::OrFilter.new(mail_key, *arguments)
      filters << ::LDAP::Filter::Base.new(:cn, arguments.join('*'))
      filters << ::LDAP::Filter::Base.new(:givenName, arguments.first)
      filters << ::LDAP::Filter::Base.new(:sn, arguments.last)
      ::LDAP::Filter::OrFilter.new filters
    end

    class InetOrgPerson
      def to_user
        ::User.new(
          first_name: givenName.first,
          last_name: sn.first,
          login: uid.first,
          email: mail.first
        )
      end
    end
  end
end
