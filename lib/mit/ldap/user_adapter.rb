module MIT
  module LDAP
    module UserAdapter

      def self.build_users(search, options = {})
        return [] unless LDAP.connected?

        filter = construct_filter(search)
        LDAP.search(filter: filter.to_s, limit: 20).
          select { |result| result.kind_of?(MIT::LDAP::InetOrgPerson) && result.valid? }.
          map(&:to_user)

      rescue RuntimeError
        LDAP.reconnect!
        !options[:rescued] && LDAP.connected? ? build_users(search, rescued: true) : []
      end

      def self.construct_filter(search)
        arguments = search.split

        filter = {}

        if arguments.size > 1
          filter[:cn] = arguments.join('*') + '*'
          filter[:sn] = arguments.last + '*'
          filter[:mail] = filter[:uid] = arguments
        else
          filter[:uid] = filter[:mail] = arguments.first
          filter[:givenName] = arguments.first
          filter[:sn] = arguments.first + '*'
        end

        ::LDAP::Filter::OrFilter.new(filter)
      end
    end

    class InetOrgPerson
      def to_user
        ::User.new(
          first_name: givenName[0],
          last_name:  sn[0],
          email:      mail[0],
          login:      uid[0],
          street:     street[0]
        )
      end

      def valid?
        %w(givenName sn mail uid).map { |attr| send(attr).present? }.all?
      end
    end
  end
end
