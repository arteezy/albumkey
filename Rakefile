# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Rails.application.load_tasks

task verbose: :environment do
  logger = Logger.new(STDOUT)
  logger.level = Logger::INFO
  Rails.logger = logger
end
