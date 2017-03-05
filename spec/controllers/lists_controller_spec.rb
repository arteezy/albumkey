require 'rails_helper'

RSpec.describe ListsController, type: :controller do
  let(:valid_session) { { user: sign_in(create :user) } }
  let(:list) { create(:list) }

  describe 'GET #index' do
    it 'returns a success response' do
      get :index
      expect(response).to be_success
    end

    it 'assigns all lists as @lists' do
      get :index
      expect(assigns(:lists)).to eq([list])
    end
  end

  describe 'GET #show' do
    it 'returns a success response' do
      get :show, id: list
      expect(response).to be_success
    end

    it 'assigns the requested list as @list' do
      get :show, id: list
      expect(assigns(:list)).to eq(list)
    end
  end

  describe 'GET #new' do
    it 'returns a success response' do
      get :new
      expect(response).to be_success
    end

    it 'assigns a new list as @list' do
      get :new
      expect(assigns(:list)).to be_a_new(List)
    end
  end

  describe 'GET #edit' do
    it 'returns a success response' do
      get :edit, id: list
      expect(response).to be_success
    end

    it 'assigns the requested list as @list' do
      get :edit, id: list
      expect(assigns(:list)).to eq(list)
    end
  end

  describe 'POST #create' do
    login_user

    context 'with valid params' do
      it 'creates a new List' do
        expect {
          post :create, list: attributes_for(:list)
        }.to change(List, :count).by(1)
      end

      it 'assigns a newly created list as @list' do
        post :create, list: attributes_for(:list)
        expect(assigns(:list)).to be_a(List)
        expect(assigns(:list)).to be_persisted
      end

      it 'redirects to the created list' do
        post :create, list: attributes_for(:list)
        expect(response).to redirect_to(List.last)
      end
    end

    context 'with invalid params' do
      it 'assigns a newly created but unsaved list as @list' do
        post :create, list: attributes_for(:invalid_list)
        expect(assigns(:list)).to be_a_new(List)
      end

      it 're-renders the new template' do
        post :create, list: attributes_for(:invalid_list)
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    login_user

    context 'with valid params' do
      it 'updates the requested list' do
        patch :update, id: list, list: attributes_for(:list, title: 'Lorem Ipsum')
        list.reload
        expect(list.title).to eq('Lorem Ipsum')
      end

      it 'assigns the requested list as @list' do
        patch :update, id: list, list: attributes_for(:list)
        expect(assigns(:list)).to eq(list)
      end

      it 'redirects to the list' do
        patch :update, id: list, list: attributes_for(:list)
        expect(response).to redirect_to(list)
      end
    end

    context 'with invalid params' do
      it 'assigns the list as @list' do
        patch :update, id: list, list: attributes_for(:invalid_list)
        expect(assigns(:list)).to eq(list)
      end

      it 're-renders the edit template' do
        patch :update, id: list, list: attributes_for(:invalid_list)
        expect(response).to render_template :edit
      end
    end
  end

  describe 'DELETE #destroy' do
    login_user

    it 'destroys the requested list' do
      list
      expect {
        delete :destroy, id: list
      }.to change(List, :count).by(-1)
    end

    it 'redirects to the lists list' do
      delete :destroy, id: list
      expect(response).to redirect_to(lists_url)
    end
  end
end
