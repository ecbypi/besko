class UsersController < ApplicationController
  respond_to :json

  def index
    users = []
    query = params[:term]
    options = params.fetch(:options, {})

    unless query.present? && options[:directory_only]
      users.concat User.search(query)
    end

    unless query.present? && options[:local_only]
      users.concat User.directory_search(query)
    end

    users.uniq! { |user| user.email }

    respond_with(users)
  end

  def create
    user = User.assign_password(params[:user])
    user.save

    respond_with(user)
  end
end
