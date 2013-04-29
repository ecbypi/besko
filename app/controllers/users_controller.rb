class UsersController < ApplicationController
  respond_to :json

  def index
    users = []
    query = params[:term]
    options = params.fetch(:options, {})

    if query.blank?
      respond_with(users)
      return
    end

    unless options[:directory_only]
      users.concat User.search(query)
    end

    unless options[:local_only]
      users.concat User.directory_search(query)
    end

    users.uniq! { |user| user.email }

    respond_with(users)
  end

  def create
    user = User.new(params[:user])
    user.assign_password.save

    respond_with(user)
  end
end
