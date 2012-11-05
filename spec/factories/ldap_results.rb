FactoryGirl.define do
  factory :ldap_entry, class: OpenStruct do
    givenName ['Micro']
    sn        ['Helpline']
    mail      ['mrhalp@mit.edu']
    uid       ['mrhalp']
    street    ['N42']
  end
end
