class AlbumPolicy
  attr_reader :user, :album

  def initialize(user, album)
    @user = user
    @album = album
  end

  def index?
    true
  end

  def show?
    true
  end

  def search?
    @user
  end

  def create?
    @user.admin? if @user
  end

  def new?
    create?
  end

  def update?
    create?
  end

  def edit?
    create?
  end

  def destroy?
    create?
  end
end
