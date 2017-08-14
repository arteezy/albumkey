describe PagePolicy do
  subject { described_class }
  let(:user) { create(:user) }
  let(:admin) { create(:user, role: :admin) }

  permissions :status? do
    it 'grants access if user is admin' do
      expect(subject).to permit(admin)
    end

    it 'denies access if user is not admin' do
      expect(subject).not_to permit(user)
    end

    it 'denies access if user is not authorized' do
      expect(subject).not_to permit(nil)
    end
  end
end
