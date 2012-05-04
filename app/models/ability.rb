class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    can [:read, :update], Receipt, recipient_id: user.id if user.receipts.present?

    if user.besk_worker?
      can [:read, :create], Delivery
    end

    if user.admin?
      can :manage, UserRole
    end
  end
end
