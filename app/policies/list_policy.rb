class ListPolicy
  attr_reader :user, :list

  def initialize(user, list)
    @user = user
    @list = list
  end

  def index?
    true
  end

  def show?
    true
  end

  def create?
    @user
  end

  def new?
    create?
  end

  def update?
    if @user
      @list.user == @user || @user.admin?
    else
      false
    end
  end

  def edit?
    update?
  end

  def move_album?
    update?
  end

  def delete_album?
    update?
  end

  def destroy?
    update?
  end
end
