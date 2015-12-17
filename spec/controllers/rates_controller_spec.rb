require 'rails_helper'

describe RatesController, type: :controller do
  let(:valid_session) { { user_id: sign_in(create :user) } }
  let(:album) { create(:album) }

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Rate if it doesnt exist' do
        expect {
          post :create, attributes_for(:rate, album_id: album), valid_session
        }.to change(Rate, :count).by(1)
      end

      it 'updates an existing Rate' do
        dummy = create(:rate, rate: 7.8, album: album, user_id: valid_session[:user_id].first)
        expect {
          post :create, attributes_for(:rate, rate: 9.1, album_id: album.id), valid_session
        }.to_not change(Rate, :count)
        dummy.reload
        expect(dummy.rate).to eq(9.1)
      end

      it 'responds with HTTP 201 Created' do
        post :create, attributes_for(:rate, album_id: album), valid_session
        expect(response).to have_http_status(:created)
      end

      it 'doesnt redirect to the created Rate' do
        post :create, attributes_for(:rate, album_id: album), valid_session
        expect(response).to_not redirect_to(Rate.last)
      end
    end

    context 'with invalid params' do
      it 'doesnt create a new Rate' do
        expect {
          post :create, attributes_for(:invalid_rate, album_id: album), valid_session
        }.to_not change(Rate, :count)
      end

      it 'responds with HTTP 400 Bad Request' do
        post :create, attributes_for(:invalid_rate, album_id: album), valid_session
        expect(response).to have_http_status(:bad_request)
      end
    end
  end
end
