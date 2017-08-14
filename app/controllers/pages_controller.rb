class PagesController < ApplicationController
  after_action :verify_authorized, only: :status

  def landing
    render layout: false
  end

  def robots
    respond_to :text
    expires_in 1.days, public: true
  end

  def sitemap
    redirect_to "https://s3.#{ENV['FOG_REGION']}.amazonaws.com/#{ENV['FOG_DIRECTORY']}/sitemaps/sitemap.xml.gz"
  end

  def status
    @status = {
      ruby:        RUBY_VERSION,
      rails:       Rails.version,
      puma:        Gem.loaded_specs['puma'].version,
      mongodb:     Mongoid.default_client.command(serverStatus: 1).first[:version],
      time:        Time.now.to_s(:long),
      album_count: Album.count,
      user_count:  User.count,
      rate_count:  Rate.count,
      list_count:  List.count
    }
    authorize :page
  end
end
