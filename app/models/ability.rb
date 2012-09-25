class Ability
  include CanCan::Ability

  def initialize(user)
    return unless user

    can [:read, :update], Receipt, recipient_id: user.id

    if user.besk_worker?
      can [:read, :create], Delivery
      can :new, Receipt
    end

    if user.admin?
      can :manage, UserRole
    end
  end
end
