class UsersController < ApplicationController
  respond_to :json

  def index
    authorize!(:index, User)

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
      users.concat DirectorySearch.lookup(query)
    end

    users.uniq! { |user| user.email }

    respond_with(users)
  end

  def create
    user = User.new(user_params)
    user.assign_password

    authorize!(:create, user)

    user.save

    respond_with(user)
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :street, :email, :login)
  end
end
