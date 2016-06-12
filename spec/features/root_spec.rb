require 'spec_helper'

describe 'App' do
  it "signs in with twitter", type: :feature do
    visit '/'
    expect(page).to have_content 'Twitter'

    click_link "Twitter"

    expect(page).to have_content("Test User")
  end
end