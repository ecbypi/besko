class Ability
  include CanCan::Ability

  def initialize(user)
    return unless user

    can [:read, :update], Receipt, user_id: user.id

    if user.besk_worker?
      can [:read, :create], Delivery
      can :new, Receipt
      can :create, Recipient
    end

    if user.mail_forwarder?
      can :create, :forwarding_label
    end

    if user.admin?
      can :manage, UserRole
      can [:read, :destroy], Delivery
    end
  end
end
