require 'rails_helper'

describe UsersController, type: :controller do
  let(:user) { create(:user) }

  context 'user is not authorized' do
    login_user

    describe 'GET #index' do
      it 'redirects to root with alert' do
        get :index
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to match(/You are not authorized to perform this action/)
      end
    end

    describe 'GET #show' do
      it 'redirects to root with alert' do
        get :show, id: user
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to match(/You are not authorized to perform this action/)
      end
    end

    describe 'PATCH #update' do
      it 'redirects to root with alert' do
        patch :update, id: user
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to match(/You are not authorized to perform this action/)
      end
    end

    describe 'DELETE #destroy' do
      it 'redirects to root with alert' do
        delete :destroy, id: user
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to match(/You are not authorized to perform this action/)
      end
    end
  end

  context 'user is authorized' do
    login_admin

    describe 'GET #index' do
      it 'assigns all users as @users' do
        get :index
        expect(assigns(:users)).to match_array([user, subject.current_user])
      end

      it 'renders the index template' do
        get :index
        expect(response).to render_template :index
      end
    end

    describe 'GET #show' do
      it 'assigns the requested user as @user' do
        get :show, id: user
        expect(assigns(:user)).to eq(user)
      end

      it 'renders the show template' do
        get :show, id: user
        expect(response).to render_template :show
      end
    end

    describe 'PATCH #update' do
      context 'with valid params' do
        it 'updates the requested user' do
          patch :update, id: user, user: attributes_for(:user, role: :admin)
          user.reload
          expect(user.role).to eq(:admin)
        end

        it 'assigns the requested user as @user' do
          patch :update, id: user, user: attributes_for(:user)
          expect(assigns(:user)).to eq(user)
        end

        it 'redirects to the users index page with notice' do
          patch :update, id: user, user: attributes_for(:user)
          expect(response).to redirect_to(users_path)
          expect(flash[:notice]).to match(/User updated/)
        end
      end

      context 'with invalid params' do
        it 'assigns the user as @user' do
          patch :update, id: user, user: attributes_for(:user, role: nil)
          expect(assigns(:user)).to eq(user)
        end

        it 'redirects to the users index page with alert' do
          patch :update, id: user, user: attributes_for(:user, role: nil)
          expect(response).to redirect_to(users_path)
          expect(flash[:alert]).to match(/Unable to update user/)
        end
      end
    end

    describe 'DELETE #destroy' do
      it 'destroys the requested user' do
        user
        expect {
          delete :destroy, id: user
        }.to change(User, :count).by(-1)
      end

      it 'refuses to destroy himself (current_user)' do
        delete :destroy, id: subject.current_user
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to match(/You are not authorized to perform this action/)
      end

      it 'redirects to the users list with notice' do
        delete :destroy, id: user
        expect(response).to redirect_to(users_path)
        expect(flash[:notice]).to match(/User deleted/)
      end
    end
  end
end
