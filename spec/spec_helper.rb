require 'rspec'
require 'rack/test'
require_relative '../app'
require 'capybara'
require 'capybara/dsl'
require 'capybara/rspec'

ENV['RACK_ENV'] = 'test'

RSpec.configure do |conf|
  # conf.include Rack::Test::Methods
  conf.include Capybara::DSL, type: :feature
end

Capybara.configure do |c|
  # c.javascript_driver = :rack_test
  c.default_driver = :rack_test
  c.app = Sinatra::Application.new
end