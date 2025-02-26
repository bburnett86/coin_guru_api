require 'rails_helper'

RSpec.describe User, type: :model do
  it "is valid with valid attributes" do
    user = FactoryBot.build(:user)
    expect(user).to be_valid
  end

  it "is not valid without a username" do
    user = FactoryBot.build(:user, username: nil)
    expect(user).to_not be_valid
  end

  it "is not valid without a first name" do
    user = FactoryBot.build(:user, first_name: nil)
    expect(user).to_not be_valid
  end

  it "is not valid without a last name" do
    user = FactoryBot.build(:user, last_name: nil)
    expect(user).to_not be_valid
  end

  it "is not valid without a unique username" do
    FactoryBot.create(:user, username: "testuser")
    user = FactoryBot.build(:user, username: "testuser")
    expect(user).to_not be_valid
  end
end