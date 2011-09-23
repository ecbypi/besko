module UserSessionMacros
  def current_user
    current_user_session.try(:user)
  end

  def current_user_session
    UserSession.find
  end

  def login(user)
    UserSession.create(user)
  end
end
