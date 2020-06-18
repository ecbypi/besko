FactoryBot.define do
  factory :ldap_entry, class: OpenStruct do
    givenName { 'Micro' }
    sn        { 'Helpline' }
    uid       { 'mrhalp' }
    street    { 'N42' }
    cn        { |proxy| "#{proxy.givenName} #{proxy.sn}" }
    mail      { |proxy| "#{proxy.uid}@mit.edu" }
  end
end
