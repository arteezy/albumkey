require 'rails_helper'

describe AlbumsController, type: :controller do
  # This should return the minimal set of attributes required to create a valid
  # Album. As you add validations to Album, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # AlbumsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET #index" do
    it "assigns all albums as @albums" do
      album = Album.create! valid_attributes
      get :index, {}, valid_session
      expect(assigns(:albums)).to eq([album])
    end
  end

  describe "GET #show" do
    it "assigns the requested album as @album" do
      album = Album.create! valid_attributes
      get :show, {:id => album.to_param}, valid_session
      expect(assigns(:album)).to eq(album)
    end
  end

  describe "GET #new" do
    it "assigns a new album as @album" do
      get :new, {}, valid_session
      expect(assigns(:album)).to be_a_new(Album)
    end
  end

  describe "GET #edit" do
    it "assigns the requested album as @album" do
      album = Album.create! valid_attributes
      get :edit, {:id => album.to_param}, valid_session
      expect(assigns(:album)).to eq(album)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Album" do
        expect {
          post :create, {:album => valid_attributes}, valid_session
        }.to change(Album, :count).by(1)
      end

      it "assigns a newly created album as @album" do
        post :create, {:album => valid_attributes}, valid_session
        expect(assigns(:album)).to be_a(Album)
        expect(assigns(:album)).to be_persisted
      end

      it "redirects to the created album" do
        post :create, {:album => valid_attributes}, valid_session
        expect(response).to redirect_to(Album.last)
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved album as @album" do
        post :create, {:album => invalid_attributes}, valid_session
        expect(assigns(:album)).to be_a_new(Album)
      end

      it "re-renders the 'new' template" do
        post :create, {:album => invalid_attributes}, valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested album" do
        album = Album.create! valid_attributes
        put :update, {:id => album.to_param, :album => new_attributes}, valid_session
        album.reload
        skip("Add assertions for updated state")
      end

      it "assigns the requested album as @album" do
        album = Album.create! valid_attributes
        put :update, {:id => album.to_param, :album => valid_attributes}, valid_session
        expect(assigns(:album)).to eq(album)
      end

      it "redirects to the album" do
        album = Album.create! valid_attributes
        put :update, {:id => album.to_param, :album => valid_attributes}, valid_session
        expect(response).to redirect_to(album)
      end
    end

    context "with invalid params" do
      it "assigns the album as @album" do
        album = Album.create! valid_attributes
        put :update, {:id => album.to_param, :album => invalid_attributes}, valid_session
        expect(assigns(:album)).to eq(album)
      end

      it "re-renders the 'edit' template" do
        album = Album.create! valid_attributes
        put :update, {:id => album.to_param, :album => invalid_attributes}, valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested album" do
      album = Album.create! valid_attributes
      expect {
        delete :destroy, {:id => album.to_param}, valid_session
      }.to change(Album, :count).by(-1)
    end

    it "redirects to the albums list" do
      album = Album.create! valid_attributes
      delete :destroy, {:id => album.to_param}, valid_session
      expect(response).to redirect_to(albums_url)
    end
  end

end
