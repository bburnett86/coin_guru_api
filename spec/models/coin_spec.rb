require 'rails_helper'

RSpec.describe Coin, type: :model do
  it "is valid with valid attributes" do
    coin = FactoryBot.build(:coin)
    expect(coin).to be_valid
  end

  it "is not valid without a name" do
    coin = FactoryBot.build(:coin, name: nil)
    expect(coin).to_not be_valid
  end

  it "is not valid without a symbol" do
    coin = FactoryBot.build(:coin, symbol: nil)
    expect(coin).to_not be_valid
  end

  it "is not valid with a duplicate name" do
    FactoryBot.create(:coin, name: "Bitcoin")
    coin = FactoryBot.build(:coin, name: "Bitcoin")
    expect(coin).to_not be_valid
  end
end
