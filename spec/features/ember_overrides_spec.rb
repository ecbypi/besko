require 'spec_helper'

feature 'Overriding Ember', js: true do
  scenario 'allows visiting pages not in the Ember router with search params' do
    visit new_user_session_path(debug: 1)

    current_url.should match /\/login\?debug=1/
  end
end
