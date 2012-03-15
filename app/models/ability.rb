class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    can [:read, :update], Receipt, recipient_id: user.id if user.receipts.present?

    if user.has_role? :besk_worker
      can [:read, :create], Delivery
    end
  end
end
