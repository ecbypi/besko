class Ability
  include CanCan::Ability

  def initialize(user)
    return unless user

    can :read, Receipt, user_id: user.id

    if user.desk_worker?
      can [:read, :create], Delivery
      can [:new, :update], Receipt
      can :create, Recipient
    end

    if user.admin?
      can [:read, :destroy], Delivery
    end
  end
end
