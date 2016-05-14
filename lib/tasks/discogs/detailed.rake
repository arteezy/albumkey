namespace :discogs do
  desc 'Request detailed Discogs info'
  task detailed: :verbose do
    puts 'Parsing Discogs...'
    app_name = Rails.application.class.parent_name
    wrapper = Discogs::Wrapper.new(app_name, user_token: ENV['DISCOGS_TOKEN'])
    dps = DiscogsParserService.new(wrapper)
    dps.request_detailed_info
    puts 'Done'
  end
end
