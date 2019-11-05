source 'https://rubygems.org'

ruby '2.5.3'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.0.1'
# Use Puma as application server
gem 'puma', '~> 4.0.1'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0.7'
# Use Bootstrap as CSS framework
gem 'bootstrap-sass', '~> 3.3.5'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '~> 3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2.2'
# Use HAMLit for faster templates
gem 'hamlit', '~> 2.6'
# Use Mongo gem as Ruby driver for MongoDB
gem 'mongo', '~> 2.10.1'
# Use Mongoid as ODM for MongoDB
gem 'mongoid', '~> 7.0.5'
# Use Devise as authentication library
gem 'devise', '~> 4.7.0'
# Use Pundit for role-based authorization
gem 'pundit', '~> 1.1'
# Use Sidekiq as job queue for background processing
gem 'sidekiq', '~> 4.2.5'
# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster
gem 'turbolinks', '~> 2.5.3'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.6.4'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.1', group: :doc
# Use Loofah for HTML sanitization
gem 'loofah', '~> 2.9.1'
# Use Nokogiri as HTML parser
gem 'nokogiri', '~> 1.10.10'
# Use Kaminari gem for pagination
gem 'kaminari-actionview', '~> 1.0.1'
# Kaminari adapter for Mongoid
gem 'kaminari-mongoid', '~> 1.0.2'
# Use Mongoid Slug as slug generator for beautiful URLs
gem 'mongoid-slug', '~> 6.0.1'
# Use Enumerize gem for enum support in Mongoid
gem 'enumerize', '~> 2.2.2'
# Ruby wrapper for ImageMagick command line utility
gem 'mini_magick', '~> 4.8.0'
# Use Gravtastic gem to add Gravatar support
gem 'gravtastic'
# Use Simple Form gem to simplify form creation
gem 'simple_form', '~> 4.1.0'
# Use this gem to generate sitemap and ping search engines
gem 'sitemap_generator'
# Data for MIME content type definitions
gem 'mime-types'
# Use Discogs Wrapper gem to easily interact with the Discogs API
gem 'discogs-wrapper'
# Use fog-aws as an interface to Amazon Web Services
gem 'fog-aws', '~> 1.4.0'
# Use Whenever gem to manage Cron jobs
gem 'whenever'
# Use TZInfo Data as data source for time zones
gem 'tzinfo-data'
# Use Awesome Print to make debugging more visually comprehensive
gem 'awesome_print'
# Use FFI to lock dependency of the Listen gem
gem 'ffi', '~> 1.15.5'
# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

group :development, :test do
  # Use RSpec for advanced testing
  gem 'rspec-rails', '~> 4.0.1'
  # Use Factory Bot as factories generator for specs
  gem 'factory_bot_rails', '~> 5.1.1'
  # Call 'binding.pry' anywhere in the code to stop execution and get a debugger console
  gem 'pry-byebug', '~> 3.6.0'
  # Use RuboCop for code style checking and formatting
  gem 'rubocop-rails', '~> 2.14.2', require: false
  gem 'rubocop-rspec', '~> 2.1', require: false
end

group :development, :deploy do
  # Use Capistrano for deployment
  gem 'capistrano', '~> 3.4.1'
  # Use Airbrussh to nicely format deployment log output
  gem 'airbrussh', require: false
  # Rails tasks for capistrano
  gem 'capistrano-rails', require: false
  # Bundler tasks for capistrano
  gem 'capistrano-bundler', require: false
  # Rbenv tasks for capistrano
  gem 'capistrano-rbenv', require: false
  # Puma tasks for capistrano
  gem 'capistrano3-puma', require: false
  # Check CI status before deployment
  gem 'capistrano-ci', require: false
end

group :development do
  # Spring speeds up development by keeping your application running in the background
  gem 'spring', '~> 2.0'
  # This gem implements the rspec command for Spring
  gem 'spring-commands-rspec'
  # This gem makes Spring watch the filesystem for changes using Listen rather than by polling the filesystem
  gem 'spring-watcher-listen'
  # Use Rack Mini Profiler for advanced performance profiling
  gem 'rack-mini-profiler', '~> 1.0.1'
  # Use Bullet gem to find slow queries and unused eager loading
  gem 'bullet', '~> 5.7'
  # Use Pry as Rails console replacement
  gem 'pry-rails'
  # Use Better Errors gem to replace errors page
  gem 'better_errors'
  # Use binding_of_caller gem to enable live REPL on error pages
  gem 'binding_of_caller'
end

group :test do
  # Add `assigns` and `assert_template` methods for controller testing
  gem 'rails-controller-testing', '~> 1.0.2'
  # Use Faker gem to generate fake test data
  gem 'faker', '~> 1.4'
  # Use Capybara for integration specs
  gem 'capybara', '~> 2.4'
  # Use DatabaseCleaner to wipe DB before tests
  gem 'database_cleaner', '~> 1.5'
  # Use Launchy as helper to Capybara specs
  gem 'launchy', '~> 2.4'
  # Use simplecov to measure test coverage
  gem 'simplecov', '~> 0.16.1'
end

group :production do
  # Add LogEntries log monitoring
  gem 'le'
  # Add Sentry for error reporting
  gem 'sentry-raven'
  # Use New Relic as monitoring service
  gem 'newrelic_rpm'
  # Use Skylight as alternative monitoring service
  gem 'skylight', '~> 2.0.1'
end
