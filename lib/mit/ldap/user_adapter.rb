module MIT
  module LDAP
    module UserAdapter

      def self.build_users search
        filter = construct_filter search
        results = Search.search filter: filter.to_s
        results.select! { |result| result.kind_of? MIT::LDAP::Search::InetOrgPerson }
        results.map(&:to_user)
      end

      def self.construct_filter search
        arguments = search.split
        mail_key = search =~ /@mit\.edu/ ? :mail : :uid
        filter = {}
        filter[mail_key] = arguments.size.eql?(1) ? arguments.first : arguments
        filter[:cn] = arguments.join('*') if arguments.size > 1
        if arguments.size == 1
          filter[:givenName] = arguments.first
          filter[:sn] = arguments.last
        end
        ::LDAP::Filter::OrFilter.new filter
      end
    end

    module Search

      class InetOrgPerson
        def to_user
          ::User.new(
            first_name: givenName[0],
            last_name: sn[0],
            login: uid[0],
            email: mail[0]
          )
        end
      end
    end
  end
end
