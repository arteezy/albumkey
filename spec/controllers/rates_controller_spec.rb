require 'rails_helper'

describe RatesController, type: :controller do
  describe "POST #create" do
    before :each do
      @album = create(:album)
      @user = create(:user)
      sign_in @user
    end

    context "with valid params" do
      it "creates a new Rate if it doesn't exist" do
        expect {
          post :create, attributes_for(:rate, album_id: @album)
        }.to change(Rate, :count).by(1)
      end

      it "updates an existing Rate" do
        dummy = create(:rate, rate: 7.8, album: @album, user: @user)
        expect {
          post :create, attributes_for(:rate, rate: 9.1, album_id: @album.id, user_id: @user)
        }.to_not change(Rate, :count)
        dummy.reload
        expect(dummy.rate).to eq(9.1)
      end

      it "responds with HTTP 201 Created" do
        post :create, attributes_for(:rate, album_id: @album)
        expect(response).to have_http_status(:created)
      end

      it "doesn't redirect to the created Rate" do
        post :create, attributes_for(:rate, album_id: @album)
        expect(response).to_not redirect_to(Rate.last)
      end
    end

    context "with invalid params" do
      it "doesn't create a new Rate" do
        expect {
          post :create, attributes_for(:invalid_rate, album_id: @album)
        }.to_not change(Rate, :count)
      end

      it "responds with HTTP 400 Bad Request" do
        post :create, attributes_for(:invalid_rate, album_id: @album)
        expect(response).to have_http_status(:bad_request)
      end
    end
  end
end
