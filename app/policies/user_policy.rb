class UserPolicy
  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope.where(id: user.id)
    end
  end

  attr_reader :signed_in_user, :user

  def initialize(signed_in_user, user)
    @signed_in_user = signed_in_user
    @user = user
  end

  def create?
    false
  end

  def destroy?
    false
  end

  def new?
    false
  end

  def show?
    signed_in_user == user
  end

  # user can update the contents of container
  def update?
    signed_in_user == user
  end
end
