require "spec_helper"

RSpec.describe DirectorySearch do
  it "returns proxies with the same methods as `User`" do
    PeopleApiStub.setup

    users = DirectorySearch.new('micro helpline').run

    expect(users).not_to be_empty # Ensures stubbing worked correctly

    user = users.first

    expect(user.first_name).to eq 'Micro'
    expect(user.last_name).to eq 'Helpline'
    expect(user.email).to eq 'mrhalp@mit.edu'
  end

  it "filters out results missing required attributes" do
    required_attributes = %w( givenname surname email )

    required_attributes.each do |attribute|
      PeopleApiStub.setup(attribute.to_sym => '')

      users = DirectorySearch.new('micro helpline').run

      expect(users).to be_empty
    end
  end
end
