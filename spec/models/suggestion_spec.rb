require 'rails_helper'

RSpec.describe Suggestion, type: :model do
  it "is valid with valid attributes" do
    suggestion = FactoryBot.create(:suggestion)
    expect(suggestion).to be_valid
  end

  it "is not valid without a suggestion_type" do
    suggestion = FactoryBot.create(:suggestion, suggestion_type: nil)
    expect(suggestion).to_not be_valid
  end

  it "is not valid without a coin_id" do
    suggestion = FactoryBot.create(:suggestion, coin: nil)
    expect(suggestion).to_not be_valid
  end

  it "is valid without a user_id if suggestion_type is public" do
    suggestion = FactoryBot.create(:suggestion, suggestion_type: "public_suggestion", user: nil)
    expect(suggestion).to be_valid
  end

  it "is not valid without a user_id if suggestion_type is custom" do
    suggestion = FactoryBot.create(:suggestion, :custom, user: nil)
    expect(suggestion).to_not be_valid
  end

  it "is not valid with a user_id if suggestion_type is public" do
    user = FactoryBot.create(:user)
    suggestion = FactoryBot.create(:suggestion, suggestion_type: "public_suggestion", user: user)
    expect(suggestion).to_not be_valid
    expect(suggestion.errors[:user_id]).to include("must be blank for public suggestions")
  end

  it "is valid with a user_id if suggestion_type is custom" do
    user = FactoryBot.create(:user)
    suggestion = FactoryBot.create(:suggestion, :custom, user: user)
    expect(suggestion).to be_valid
  end

  describe "#picks_of_the_day" do
    it "returns the specified number of public suggestions" do
      FactoryBot.create_list(:suggestion, 3, suggestion_type: "public_suggestion")
      picks = Suggestion.new.picks_of_the_day(2)
      expect(picks.count).to eq(2)
      expect(picks.all? { |pick| pick.suggestion_type == "public_suggestion" }).to be true
    end
  end

  describe "#public_pick_history" do
    it "returns public suggestions in descending order of creation" do
      suggestion1 = FactoryBot.create(:suggestion, suggestion_type: "public_suggestion", created_at: 1.day.ago)
      suggestion2 = FactoryBot.create(:suggestion, suggestion_type: "public_suggestion", created_at: 2.days.ago)
      history = Suggestion.new.public_pick_history
      expect(history).to eq([suggestion1, suggestion2])
      expect(history.all? { |pick| pick.suggestion_type == "public_suggestion" }).to be true
    end
  end

  describe "#user_pick_history" do
    it "returns suggestions for a specific user in descending order of creation" do
      user = FactoryBot.create(:user)
      suggestion1 = FactoryBot.create(:suggestion, :custom, user: user, created_at: 1.day.ago)
      suggestion2 = FactoryBot.create(:suggestion, :custom, user: user, created_at: 2.days.ago)
      history = Suggestion.new.user_pick_history(user.id)
      expect(history).to eq([suggestion1, suggestion2])
      expect(history.all? { |pick| pick.user_id == user.id }).to be true
    end
  end
end