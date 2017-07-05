describe AlbumPolicy do
  subject { described_class }
  let(:user) { create(:user) }
  let(:admin) { create(:user, role: :admin) }
  let(:album) { create(:album) }

  permissions :index?, :show? do
    it 'grants access to anyone' do
      expect(subject).to permit(nil, album)
    end
  end

  permissions :search? do
    it 'grants access if user is authorized' do
      expect(subject).to permit(user, album)
    end

    it 'denies access if user is not authorized' do
      expect(subject).not_to permit(nil, album)
    end
  end

  permissions :create?, :new?, :update?, :edit?, :destroy? do
    it 'grants access if user is admin' do
      expect(subject).to permit(admin, album)
    end

    it 'denies access if user is not admin' do
      expect(subject).not_to permit(user, album)
    end

    it 'denies access if user is not authorized' do
      expect(subject).not_to permit(nil, album)
    end
  end
end
