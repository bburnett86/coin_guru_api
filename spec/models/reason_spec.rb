require 'rails_helper'

RSpec.describe Reason, type: :model do
  it "is valid with valid attributes" do
    reason = FactoryBot.build(:reason)
    expect(reason).to be_valid
  end

  it "is not valid without a type" do
    reason = FactoryBot.build(:reason, type: nil)
    expect(reason).to_not be_valid
  end

  it "is not valid without a description" do
    reason = FactoryBot.build(:reason, description: nil)
    expect(reason).to_not be_valid
  end

  it "is not valid without a suggestion" do
    reason = FactoryBot.build(:reason, suggestion: nil)
    expect(reason).to_not be_valid
  end
end