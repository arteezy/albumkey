namespace :albums do
  desc 'Update albums from Pitchfork and update their slugs'
  task update: :verbose do
    Rake::Task['albums:getlatest'].invoke
    Rake::Task['slugs:update'].invoke
  end
end
