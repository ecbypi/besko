module MIT
  module LDAP
    def self.search(*args)
      []
    end

    class InetOrgPerson

      def initialize(attributes = {})

        attributes.each do |attribute, value|
          instance_eval <<-METHODS, __FILE__, __LINE__ + 1
            def #{attribute}
              @#{attribute}
            end

            def #{attribute}=(value)
              @#{attribute} = [value].compact
            end
          METHODS

          send("#{attribute}=", value)
        end

      end

      def [](attribute)
        instance_variable_get("@#{attribute}")
      end

    end unless defined?(MIT::LDAP::InetOrgPerson)
  end
end

module LDAPSearchStubbing

  def ldap_result(attributes = {})
    attributes.reverse_merge!(FactoryGirl.attributes_for(:mrhalp))

    MIT::LDAP::InetOrgPerson.new(
      givenName: attributes[:first_name],
      sn: attributes[:last_name],
      uid: attributes[:login],
      mail: attributes[:email],
      cn: [attributes[:first_name], attributes[:last_name]].join(' '),
      street: attributes[:street]
    )
  end

  def stub_mit_ldap_search_results(attributes = {})
    result = ldap_result(attributes)
    MIT::LDAP.stub(:connected?).and_return(true)
    MIT::LDAP.stub(:search).and_return([result])
    result
  end

  def stub_ldap!(attributes = {})
    attributes.reverse_merge!(attributes_for(:ldap_entry))

    attributes.stringify_keys!

    MIT::LDAP.stub(:search).and_return([attributes])
  end
end
