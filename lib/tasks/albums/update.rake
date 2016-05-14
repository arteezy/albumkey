namespace :albums do
  desc 'Update albums, update their slugs and update Discogs'
  task update: :verbose do
    Rake::Task['albums:getlatest'].invoke
    Rake::Task['slugs:update'].invoke
    Rake::Task['discogs:update'].invoke
    Rake::Task['discogs:detailed'].invoke
  end
end
