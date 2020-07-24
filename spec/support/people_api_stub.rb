module PeopleApiStub
  module_function

  def setup(attributes = {})
    attributes.reverse_merge! FactoryBot.attributes_for(:ldap_entry)

    WebMock.
      stub_request(:get, Regexp.new(PeopleApi::URI.host)).
      to_return(status: 200, body: [attributes].to_json)
  end
end
