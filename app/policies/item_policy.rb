class ItemPolicy
  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope_user = user
      scope.all.branch { container.where(user: scope_user) }
    end
  end

  attr_reader :user, :item

  def initialize(user, item)
    @user = user
    @item = item
  end

  def create?
    user == item.container.try!(:user)
  end

  def destroy?
    user == item.container.user
  end

  def edit?
    user == item.container.user
  end

  def new?
    container = item.container

    container.nil? || user == container.user
  end

  def show?
    user == item.container.user
  end

  # user can update the contents of container
  def update?
    user == item.container.user
  end
end
