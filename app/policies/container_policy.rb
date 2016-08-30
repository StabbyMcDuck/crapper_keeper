class ContainerPolicy
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

  attr_reader :user, :container

  def initialize(user, container)
    @user = user
    @container = container
  end

  # user can update the contents of container
  def update?
    user == container.user
  end

  def show?
    user == container.user
  end
end
