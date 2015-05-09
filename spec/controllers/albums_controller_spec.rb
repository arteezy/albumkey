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
      album = create(:album)
      get :index
      expect(assigns(:albums)).to match_array([album])
    end

    it "renders the :index template" do
      get :index
      expect(response).to render_template :index
    end
  end

  describe "GET #show" do
    it "assigns the requested album as @album" do
      album = create(:album)
      get :show, id: album
      expect(assigns(:album)).to eq(album)
    end

    it "renders the :show template" do
      album = create(:album)
      get :show, id: album
      expect(response).to render_template :show
    end
  end

  describe "GET #new" do
    it "assigns a new album as @album" do
      get :new
      expect(assigns(:album)).to be_a_new(Album)
    end

    it "renders the :new template" do
      get :new
      expect(response).to render_template :new
    end
  end

  describe "GET #edit" do
    it "assigns the requested album as @album" do
      album = create(:album)
      get :edit, id: album
      expect(assigns(:album)).to eq(album)
    end

    it "renders the :edit template" do
      album = create(:album)
      get :edit, id: album
      expect(response).to render_template :edit
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Album" do
        expect {
          post :create, album: attributes_for(:album)
        }.to change(Album, :count).by(1)
      end

      it "assigns a newly created album as @album" do
        post :create, album: attributes_for(:album)
        expect(assigns(:album)).to be_a(Album)
        expect(assigns(:album)).to be_persisted
      end

      it "redirects to the created album" do
        post :create, album: attributes_for(:album)
        expect(response).to redirect_to(Album.last)
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved album as @album" do
        post :create, album: attributes_for(:invalid_album)
        expect(assigns(:album)).to be_a_new(Album)
      end

      it "re-renders the 'new' template" do
        post :create, album: attributes_for(:invalid_album)
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
      album = create(:album)
      expect {
        delete :destroy, id: album
      }.to change(Album, :count).by(-1)
    end

    it "redirects to the albums list" do
      album = create(:album)
      delete :destroy, id: album
      expect(response).to redirect_to(albums_url)
    end
  end

end
