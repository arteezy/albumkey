describe UserPolicy do
  subject { described_class }
  let(:user) { create(:user) }
  let(:admin) { create(:admin) }

  permissions :index?, :show?, :update?, :destroy? do
    it 'grants access if user is an admin' do
      expect(subject).to permit(admin, User)
    end

    it 'denies access if user is not admin' do
      expect(subject).not_to permit(user, User)
    end
  end

  permissions :show? do
    it 'grants access if user requests his own profile' do
      expect(subject).to permit(user, user)
    end

    it 'denies access if user requests other user profile' do
      expect(subject).not_to permit(user, admin)
    end
  end

  permissions :destroy? do
    it 'denies access if user tries to destroy himself' do
      expect(subject).not_to permit(user, user)
    end
  end
end
