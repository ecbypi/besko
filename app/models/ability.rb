class Ability
  include CanCan::Ability

  def initialize(user)
    can [:read, :update], Receipt, :recipient_id => user.id

    if user.has_role? :besk_worker
      can [:read, :create], Delivery
    end
  end
end
