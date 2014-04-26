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

    if user.admin?
      can [:read, :destroy], Delivery
    end
  end
end
