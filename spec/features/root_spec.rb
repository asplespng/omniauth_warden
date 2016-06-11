require 'spec_helper'

describe 'App' do
  include Rack::Test::Methods

  # def app
  #   Sinatra::Application
  # end
  # Capybara.app = Sinatra::Application.new

  it "includes twitter", type: :feature do
    visit '/'
    expect(page).to have_content 'Twitter'
    click_link "Twitter"
  end
end