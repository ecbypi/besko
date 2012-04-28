class UserDecorator < ApplicationDecorator
  decorates :user

  def as_json options={}
    options.reverse_merge!(
      as_autocomplete: false
    )

    attributes = model.as_json(
      only: [:id, :first_name, :last_name, :email, :login, :street],
      methods: [:name]
    )

    if options[:as_autocomplete]
      attributes['value'] = attributes['login']
      attributes['label'] = model.name
    end
    attributes.stringify_keys
  end
end
