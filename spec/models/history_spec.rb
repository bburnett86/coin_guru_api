# filepath: /Users/us/Desktop/dev/coin_guru/coin_guru_api/spec/models/history_spec.rb
require 'rails_helper'

RSpec.describe History, type: :model do
  it "is valid with valid attributes" do
    history = FactoryBot.build(:history)
    expect(history).to be_valid
  end

  it "is not valid without a price" do
    history = FactoryBot.build(:history, price: nil)
    expect(history).to_not be_valid
  end

  it "is not valid without a created_at" do
    history = FactoryBot.build(:history, created_at: nil)
    expect(history).to_not be_valid
  end

  it "is not valid without a coin" do
    history = FactoryBot.build(:history, coin: nil)
    expect(history).to_not be_valid
  end
end