class IdentityPolicy
  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope.where(user: user)
    end
  end

  attr_reader :user, :identity

  def initialize(user, identity)
    @user = user
    @identity = identity
  end

  def new?
    user == identity.user
  end

  def show?
    user == identity.user
  end

  # user can update the contents of identity
  def update?
    user == identity.user
  end
end
