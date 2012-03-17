class UserDecorator < ApplicationDecorator
  decorates :user

  def as_json options={}
    options.reverse_merge!(
      as_autocomplete: false
    )

    attributes = model.as_json(
      methods: ['name'],
      only: [:id, :first_name, :last_name, :email, :login]
    )

    if options[:as_autocomplete]
      attributes['value'] = attributes['login']
      attributes['label'] = attributes['name']
    end
    attributes
  end
end
