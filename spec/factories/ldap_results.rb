FactoryBot.define do
  factory :ldap_entry, class: OpenStruct do
    givenname { 'Micro' }
    surname   { 'Helpline' }
    id        { 'mrhalp' }
    office    { ['N42'] }
    name      { |proxy| "#{proxy.givenname} #{proxy.surname}" }
    email     { |proxy| ["#{proxy.id}@mit.edu"] }
    url       { |proxy| "https:\/\/m.mit.edu\/apis\/people\/#{proxy.id}" }
  end
end
