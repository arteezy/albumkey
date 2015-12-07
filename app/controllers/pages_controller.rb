class PagesController < ApplicationController
  def robots
    respond_to :text
    expires_in 1.days, public: true
  end

  def sitemap
    redirect_to "https://s3.#{ENV['FOG_REGION']}.amazonaws.com/#{ENV['FOG_DIRECTORY']}/sitemaps/sitemap.xml.gz"
  end
end
