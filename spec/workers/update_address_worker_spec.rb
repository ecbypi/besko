require 'spec_helper'

describe UpdateAddressWorker do
  describe '#perform' do
    it 'updates the address of a package recipient' do
      stub_ldap! street: '211 Mass Ave'

      user = create(:user, street: '77 Mass Ave')

      UpdateAddressWorker.perform_async

      user.reload.street.should eq '211 Mass Ave'
    end

    it 'does nothing if there is no LDAP information for the user' do
      DirectorySearch.any_instance.stub(command_output: '')

      user = create(:user, street: '77 Mass Ave')

      expect { UpdateAddressWorker.perform_async }.not_to change { user.reload.street }
    end

    it 'only updates if the user has a login' do
      stub_ldap!

      user = create(:user, street: '77 Mass Ave', login: nil)

      expect { UpdateAddressWorker.perform_async }.not_to change { user.reload.street }
    end

    it 'does not attempt to persist if street is unchanged' do
      stub_ldap! street: '77 Mass Ave'

      user = create(:user, street: '77 Mass Ave')

      expect { UpdateAddressWorker.perform_async }.not_to change { user.reload.street }
    end
  end
end
