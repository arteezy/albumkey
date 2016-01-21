class AlbumPolicy
  attr_reader :current_user, :model

  def initialize(current_user, model)
    @current_user = current_user
    @album = model
  end

  def index?
    true
  end

  def show?
    true
  end

  def create?
    @current_user.admin? if @current_user
  end

  def new?
    create?
  end

  def update?
    @current_user.admin? if @current_user
  end

  def edit?
    update?
  end

  def destroy?
    @current_user.admin? if @current_user
  end
end
