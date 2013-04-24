require 'spec_helper'

describe UpdateAddressWorker do
  before do
    stub_empty_ldap_server_configuration!
  end

  describe '#perform' do
    it 'updates the address of a package recipient' do
      stub_ldap! street: '211 Mass Ave'

      user = create(:user, street: '77 Mass Ave')

      UpdateAddressWorker.perform_async(user.id)

      user = user.reload
      user.street.should eq '211 Mass Ave'
      user.previous_addresses.last.address.should eq '77 Mass Ave'
    end

    it 'does nothing if there is no LDAP information for the user' do
      DirectorySearch.any_instance.stub(command_output: '')

      user = create(:user, street: '77 Mass Ave')
      User.any_instance.should_not_receive(:save)

      UpdateAddressWorker.perform_async(user.id)
    end

    it 'only updates if the user has a login' do
      stub_ldap!

      user = create(:user, street: '77 Mass Ave', login: nil)
      User.any_instance.should_not_receive(:save)

      UpdateAddressWorker.perform_async(user.id)
    end

    it 'does not attempt to persist if street is unchanged' do
      stub_ldap! street: '77 Mass Ave'

      user = create(:user, street: '77 Mass Ave')
      User.any_instance.should_not_receive(:save)

      UpdateAddressWorker.perform_async(user.id)
    end
  end

  describe '.update_addresses' do
    it 'updates the address of all users' do
      stub_ldap! street: 'Harrenhal'
      create_list(:user, 3)

      UpdateAddressWorker.update_addresses

      User.pluck(:street).uniq.should eq ['Harrenhal']
    end
  end
end
