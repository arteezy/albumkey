require 'rails_helper'

describe AlbumsController, type: :controller do
  context 'CRUD' do
    let(:album) { create(:album) }

    describe 'GET #index' do
      it 'assigns all albums as @albums' do
        get :index
        expect(assigns(:albums)).to match_array([album])
      end

      it 'renders the index template' do
        get :index
        expect(response).to render_template :index
      end
    end

    describe 'GET #show' do
      it 'assigns the requested album as @album' do
        get :show, params: { id: album }
        expect(assigns(:album)).to eq(album)
      end

      it 'assigns album comments as @comments' do
        comment = create(:comment, album: album)
        get :show, params: { id: album }
        expect(assigns(:comments)).to match_array([comment])
      end

      it 'renders the show template' do
        get :show, params: { id: album }
        expect(response).to render_template :show
      end

      context 'with user logged in' do
        login_user

        it 'assigns a new comment as @comment' do
          get :show, params: { id: album }
          expect(assigns(:comment)).to be_a_new(Comment)
        end

        it 'assigns the user rate of album as @rate' do
          rate = create(:rate, album: album, user: subject.current_user)
          get :show, params: { id: album }
          expect(assigns(:rate)).to eq(rate)
        end

        it 'assigns the user lists of album as @lists' do
          list = create(:list, user: subject.current_user)
          get :show, params: { id: album }
          expect(assigns(:lists)).to match_array([list])
        end
      end
    end

    describe 'GET #new' do
      context 'with admin logged in' do
        login_admin

        it 'assigns a new album as @album' do
          get :new
          expect(assigns(:album)).to be_a_new(Album)
        end

        it 'renders the new template' do
          get :new
          expect(response).to render_template :new
        end
      end

      context 'as guest' do
        it 'redirects to root' do
          get :new
          expect(response).to redirect_to(root_path)
        end
      end
    end

    describe 'GET #edit' do
      context 'with admin logged in' do
        login_admin

        it 'assigns the requested album as @album' do
          get :edit, params: { id: album }
          expect(assigns(:album)).to eq(album)
        end

        it 'renders the edit template' do
          get :edit, params: { id: album }
          expect(response).to render_template :edit
        end
      end

      context 'as guest' do
        it 'redirects to root' do
          get :edit, params: { id: album }
          expect(response).to redirect_to(root_path)
        end
      end
    end

    describe 'GET #search' do
      context 'with user logged in' do
        login_user

        it 'renders the search template' do
          get :search
          expect(response).to render_template :search
        end

        it 'assigns searched albums as @albums' do
          get :search, params: { search: album.title }
          expect(assigns(:albums)).to match_array([album])
        end
      end

      context 'as guest' do
        it 'redirects to root' do
          get :search
          expect(response).to redirect_to(root_path)
        end
      end
    end

    describe 'POST #create' do
      context 'with admin logged in' do
        login_admin

        context 'with valid params' do
          it 'creates a new Album' do
            expect {
              post :create, params: { album: attributes_for(:album) }
            }.to change(Album, :count).by(1)
          end

          it 'assigns a newly created album as @album' do
            post :create, params: { album: attributes_for(:album) }
            expect(assigns(:album)).to be_a(Album)
            expect(assigns(:album)).to be_persisted
          end

          it 'redirects to the created album' do
            post :create, params: { album: attributes_for(:album) }
            expect(response).to redirect_to(Album.last)
          end
        end

        context 'with invalid params' do
          it 'assigns a newly created but unsaved album as @album' do
            post :create, params: { album: attributes_for(:invalid_album) }
            expect(assigns(:album)).to be_a_new(Album)
          end

          it 're-renders the new template' do
            post :create, params: { album: attributes_for(:invalid_album) }
            expect(response).to render_template :new
          end
        end
      end

      context 'as guest' do
        it 'redirects to root' do
          post :create, params: { album: attributes_for(:album) }
          expect(response).to redirect_to(root_path)
        end
      end
    end

    describe 'PATCH #update' do
      let(:album) { create(:album, title: 'Illmatic', artist: ['Nas']) }

      context 'with admin logged in' do
        login_admin

        context 'with valid params' do
          it 'updates the requested album' do
            patch :update, params: { id: album, album: attributes_for(:album, title: 'Dalmatic', artist: ['Pas']) }
            album.reload
            expect(album.title).to eq('Dalmatic')
            expect(album.artist).to eq(['Pas'])
          end

          it 'assigns the requested album as @album' do
            patch :update, params: { id: album, album: attributes_for(:album) }
            expect(assigns(:album)).to eq(album)
          end

          it 'redirects to the album' do
            patch :update, params: { id: album, album: attributes_for(:album) }
            album.reload
            expect(response).to redirect_to(album)
          end
        end

        context 'with invalid params' do
          it 'assigns the album as @album' do
            patch :update, params: { id: album, album: attributes_for(:invalid_album) }
            expect(assigns(:album)).to eq(album)
          end

          it 're-renders the edit template' do
            patch :update, params: { id: album, album: attributes_for(:invalid_album) }
            expect(response).to render_template('edit')
          end
        end

        context 'adding album to list' do
          let(:list) { create(:list) }

          it 'updates the requested album with list relation' do
            patch :update, params: { id: album, album: { list_id: list } }
            album.reload
            expect(album.lists).to match_array([list])
          end

          it 'redirects to the list with newly added album' do
            patch :update, params: { id: album, album: { list_id: list } }
            album.reload
            expect(response).to redirect_to(list)
          end
        end
      end

      context 'as guest' do
        it 'redirects to root' do
          patch :update, params: { id: album, album: attributes_for(:album) }
          expect(response).to redirect_to(root_path)
        end
      end
    end

    describe 'DELETE #destroy' do
      context 'with admin logged in' do
        login_admin

        it 'destroys the requested album' do
          album
          expect {
            delete :destroy, params: { id: album }
          }.to change(Album, :count).by(-1)
        end

        it 'redirects to the albums list' do
          delete :destroy, params: { id: album }
          expect(response).to redirect_to(albums_url)
        end
      end

      context 'as guest' do
        it 'redirects to root' do
          delete :destroy, params: { id: album }
          expect(response).to redirect_to(root_path)
        end
      end
    end
  end

  context 'JSON API' do
    let!(:album) { create(:album) }

    render_views

    describe 'GET #artists' do
      it 'assigns all artists as @artists' do
        get :artists, format: :json
        expect(assigns(:artists)).to match_array(album.artist)
      end

      it 'renders the artists JSON' do
        get :artists, format: :json
        expect(response).to render_template :artists
      end

      it 'generates an array of artist names' do
        another_album = create(:album)
        get :artists, format: :json
        expect(JSON.parse(response.body)).to match_array(album.artist + another_album.artist)
      end
    end

    describe 'GET #labels' do
      it 'assigns all record labels as @labels' do
        get :labels, format: :json
        expect(assigns(:labels)).to match_array(album.label)
      end

      it 'renders the labels JSON' do
        get :labels, format: :json
        expect(response).to render_template :labels
      end

      it 'generates an array of record labels' do
        another_album = create(:album)
        get :labels, format: :json
        expect(JSON.parse(response.body)).to match_array(album.label + another_album.label)
      end
    end
  end
end
