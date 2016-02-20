namespace :discogs do
  desc 'Perform the fullscan of all registered albums on Discogs'
  task fullscan: :verbose do
    puts 'Parsing Discogs...'
    app_name = Rails.application.class.parent_name
    wrapper = Discogs::Wrapper.new(app_name, user_token: ENV['DISCOGS_TOKEN'])
    dps = DiscogsParserService.new(wrapper, 4)
    dps.thread_pool_start
    puts 'Done'
  end
end
