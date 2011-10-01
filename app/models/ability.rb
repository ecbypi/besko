class Ability
  include CanCan::Ability

  def initialize(user)
    if !user.received_packages.empty?
      can [:read, :update], Package, :recipient_id => user.id
    end

    if user.has_role? :besk_worker
      can [:review, :create], :packages
    end
  end
end
