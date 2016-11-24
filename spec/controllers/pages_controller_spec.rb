require 'rails_helper'

describe PagesController, type: :controller do
  describe 'GET #sitemap' do
    it 'redirects to Amazon S3' do
      get :sitemap
      expect(response).to redirect_to "https://s3.#{ENV['FOG_REGION']}.amazonaws.com/#{ENV['FOG_DIRECTORY']}/sitemaps/sitemap.xml.gz"
    end
  end

  describe 'GET #status' do
    it 'assigns current app status as @status' do
      get :status
      expect(assigns(:status)).to be_present
    end

    it '@status contains the right Rails version' do
      get :status
      expect(assigns(:status)[:rails]).to eq Rails.version
    end
  end
end
