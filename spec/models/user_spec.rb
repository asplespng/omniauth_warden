require 'spec_helper'

describe User do
  it 'should require name' do
    expect(FactoryGirl.build(:user, name: "")).not_to be_valid
    expect(FactoryGirl.build(:user, name: "Test")).to be_valid
  end

  it 'uid should be unique for auth_provider' do
    FactoryGirl.create(:user, auth_provider: "test", uid: "123")
    expect(FactoryGirl.build(:user, auth_provider: "test", uid: "123")).not_to be_valid
    expect(FactoryGirl.build(:user, auth_provider: "test", uid: "122")).to be_valid
  end
end