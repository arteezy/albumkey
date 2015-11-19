source 'https://rubygems.org'

ruby '2.2.3'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 4.2.1'
# Use Puma as application server
gem 'puma', '~> 2.14'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Bootstrap as CSS framework
gem 'bootstrap-sass', '~> 3.3.5'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# Use HAML for templates
gem 'haml'
# Use Mongo gem as Ruby driver for MongoDB
gem 'mongo', '~> 2.1.2'
# Use Mongoid as ODM for MongoDB
gem 'mongoid', '~> 5.0.0'
# Use Devise as authentication library
gem 'devise', '~> 3.5.2'
# Use Pundit for role-based authorization
gem 'pundit', '~> 1.0.1'
# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster
gem 'turbolinks', '~> 2.5.3'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.3'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.1', group: :doc
# Use Nokogiri as HTML parser
gem 'nokogiri', '~> 1.6.6'
# Use Kaminari gem for pagination
gem 'kaminari'
# Use Mongoid Slug as slug generator for beautiful URLs
gem 'mongoid-slug', '~> 5.1'
# Use Mongoid Enum for enum support
gem 'mongoid-enum', git: 'https://github.com/arteezy/mongoid-enum.git'
# Use Gravtastic gem to add Gravatar support
gem 'gravtastic'
# Use this gem to generate sitemap and ping search engines
gem 'sitemap_generator'
# Use fog-aws as an interface to Amazon Web Services
gem 'fog-aws'
# Use TZInfo Data as data source for time zones
gem 'tzinfo-data'

group :development, :test do
  # Use RSpec for advanced testing
  gem 'rspec-rails', '~> 3.2.1'
  # Use Factory Girl as factories generator for specs
  gem 'factory_girl_rails', '~> 4.5.0'
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
end

group :development do
  # Spring speeds up development by keeping your application running in the background
  gem 'spring'
  # Use Rack Mini Profiler for advanced performance profiling
  gem 'rack-mini-profiler'
  # Use Pry as Rails console replacement
  gem 'pry-rails'
  # Use Awesome Print to make debugging more visually comprehensive
  gem 'awesome_print'
  # Use Better Errors gem to replace errors page
  gem 'better_errors'
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'
  # Use Quiest Assets to supress assets console logging
  gem 'quiet_assets'
end

group :test do
  # Use Faker gem to generate fake test data
  gem 'faker', '~> 1.4.3'
  # Use Capybara for integration specs
  gem 'capybara', '~> 2.4.4'
  # Use DatabaseCleaner to wipe DB before tests
  gem 'database_cleaner', git: 'https://github.com/DatabaseCleaner/database_cleaner.git'
  # Use Launchy as helper to Capybara specs
  gem 'launchy', '~> 2.4.3'
  # Use Code Climate to measure test coverage and code quality
  gem 'codeclimate-test-reporter', require: nil
end

group :production do
  # 12 Factor gem for Heroku
  gem 'rails_12factor'
  # Use New Relic as monitoring service
  gem 'newrelic_rpm'
  # Use Skylight as alternative monitoring service
  gem 'skylight'
end
