require 'spec_helper'

describe 'App' do
  before :each do
  end

  it "signs in with twitter", type: :feature, js: true do
    visit '/'
    expect(page).to have_content 'Twitter'

    click_link "Twitter"
    save_screenshot '1.png'

    expect(page).to have_content("Test User")
  end
end