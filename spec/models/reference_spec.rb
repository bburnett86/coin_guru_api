require 'rails_helper'

RSpec.describe Reference, type: :model do
  it "is valid with valid attributes" do
    reference = FactoryBot.build(:reference)
    expect(reference).to be_valid
  end

  it "is not valid without a url" do
    reference = FactoryBot.build(:reference, url: nil)
    expect(reference).to_not be_valid
  end

  it "is not valid with an invalid url" do
    reference = FactoryBot.build(:reference, url: "invalid_url")
    expect(reference).to_not be_valid
  end

  it "is not valid without a description" do
    reference = FactoryBot.build(:reference, description: nil)
    expect(reference).to_not be_valid
  end

  it "is not valid without a reason" do
    reference = FactoryBot.build(:reference, reason: nil)
    expect(reference).to_not be_valid
  end
end
