ENV['RACK_ENV'] = 'test'

require 'rspec'
require 'rack/test'
require_relative '../app'
require 'capybara'
require 'capybara/dsl'
require 'capybara/rspec'
require 'capybara/webkit'
require 'database_cleaner'


RSpec.configure do |conf|
  conf.include Rack::Test::Methods, type: :controller
  conf.include Capybara::DSL, type: :feature

  # database cleaner config per http://devblog.avdi.org/2012/08/31/configuring-database_cleaner-with-rails-rspec-capybara-and-selenium/
  conf.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  conf.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  conf.before(:each, :js => true) do
    DatabaseCleaner.strategy = :truncation
  end

  conf.before(:each) do
    DatabaseCleaner.start
  end

  conf.after(:each) do
    DatabaseCleaner.clean
  end
end

Capybara.configure do |c|
  c.javascript_driver = :webkit
  c.default_driver = :webkit
  c.app = Sinatra::Application.new
end

Capybara::Webkit.configure do |config|
  # config.block_unknown_urls
end

OmniAuth.configure do |c|
  c.test_mode = true
  OmniAuth.config.add_mock(:twitter,
                           { uid: '12345',
                             provider: 'twitter',
                             info: { name: "Test User" }
                           })
end