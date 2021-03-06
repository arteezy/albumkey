require 'rails_helper'

describe CommentsController, type: :controller do
  let(:valid_session) { { user_id: sign_in(create :user) } }
  let(:album) { create(:album) }
  let(:comment) { create(:comment) }

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Comment' do
        expect {
          post :create, { comment: attributes_for(:comment), album_id: album }, valid_session
        }.to change { album.reload.comments.count }.by(1)
      end

      it 'assigns a newly created comment as @comment' do
        post :create, { comment: attributes_for(:comment), album_id: album }, valid_session
        expect(assigns(:comment)).to be_a(Comment)
        expect(assigns(:comment)).to be_persisted
      end

      it 'redirects to album page with the created comment' do
        post :create, { comment: attributes_for(:comment), album_id: album }, valid_session
        expect(response).to redirect_to(album)
      end
    end

    context 'with invalid params' do
      it 'assigns a newly created but unsaved comment as @comment' do
        post :create, { comment: attributes_for(:invalid_comment), album_id: album }, valid_session
        expect(assigns(:comment)).to be_a_new(Comment)
      end

      it 'redirects to album page with alert' do
        post :create, { comment: attributes_for(:invalid_comment), album_id: album }, valid_session
        expect(response).to redirect_to(album)
        expect(flash[:alert]).to be_present
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_params) { { body: 'Good vibes' } }

      it 'updates the requested comment' do
        put :update, { album_id: comment.album, id: comment, comment: new_params }, valid_session
        comment.reload
        expect(comment.body).to eq('Good vibes')
      end

      it 'assigns the requested comment as @comment' do
        put :update, { album_id: comment.album, id: comment, comment: new_params }, valid_session
        expect(assigns(:comment)).to eq(comment)
      end

      it 'redirects to album page' do
        put :update, { album_id: comment.album, id: comment, comment: new_params }, valid_session
        expect(response).to redirect_to(comment.album)
      end
    end

    context 'with invalid params' do
      let(:invalid_params) { { body: '' } }

      it 'assigns the comment as @comment' do
        put :update, { album_id: comment.album, id: comment, comment: invalid_params }, valid_session
        expect(assigns(:comment)).to eq(comment)
      end

      it 'redirects to album page with alert' do
        put :update, { album_id: comment.album, id: comment, comment: invalid_params }, valid_session
        expect(response).to redirect_to(comment.album)
        expect(flash[:alert]).to be_present
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested comment' do
      expect {
        delete :destroy, { album_id: comment.album, id: comment }, valid_session
      }.to change { comment.album.reload.comments.count }.by(-1)
    end

    it 'redirects to album page with alert' do
      delete :destroy, { album_id: comment.album, id: comment }, valid_session
      expect(response).to redirect_to(comment.album)
      expect(flash[:alert]).to be_present
    end
  end
end
