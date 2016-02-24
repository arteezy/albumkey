namespace :discogs do
  desc 'Update Discogs if there are albums without them'
  task update: :verbose do
    puts 'Parsing Discogs...'
    app_name = Rails.application.class.parent_name
    wrapper = Discogs::Wrapper.new(app_name, user_token: ENV['DISCOGS_TOKEN'])
    dps = DiscogsParserService.new(wrapper)
    dps.update
    puts 'Done'
  end
end
