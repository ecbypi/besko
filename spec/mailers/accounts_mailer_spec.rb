require 'spec_helper'

describe AccountsMailer do
  describe '.confirmation_instructions' do
    let(:mail) { AccountsMailer.confirmation_instructions(create(:user)) }

    it 'sends to besko@mit.edu' do
      mail.should be_delivered_to 'besko@mit.edu'
    end
  end
end
