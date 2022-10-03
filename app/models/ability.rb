class Ability
  include CanCan::Ability

  def initialize user
    can :read, [Book, CategoryBook]

    return unless user

    can %i(show update), User, id: user.id

    case user.role
    when "super_admin"
      can :manage, :all
    when "manager"
      can %i(read create update), [Book, Category, OrderDetail, Order]
      can %i(read), [Author, Publisher]
      can :read, User
    when "user"
      cannot :destroy, Order
    end
  end
end
