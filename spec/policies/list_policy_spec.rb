describe ListPolicy do
  subject { described_class }
  let(:user) { create(:user) }
  let(:admin) { create(:user, role: :admin) }
  let(:list) { create(:list) }

  permissions :index?, :show? do
    it 'grants access to anyone' do
      expect(subject).to permit(nil, List)
    end
  end

  permissions :create?, :new? do
    it 'grants access if user is authorized' do
      expect(subject).to permit(user, List)
    end

    it 'denies access if user is not authorized' do
      expect(subject).not_to permit(nil, List)
    end
  end

  permissions :update?, :edit?, :move_album?, :delete_album?, :destroy? do
    it 'grants access if user is an admin' do
      expect(subject).to permit(admin, list)
    end

    it 'grants access if user requests his own list' do
      list = create(:list, user: user)
      expect(subject).to permit(user, list)
    end

    it 'denies access if user requests other user list' do
      expect(subject).not_to permit(user, list)
    end
  end
end
