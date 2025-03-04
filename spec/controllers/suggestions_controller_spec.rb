require 'rails_helper'

RSpec.describe SuggestionsController, type: :controller do
  describe "GET #daily_picks" do
    it "returns the top 3 suggestions" do
      FactoryBot.create_list(:suggestion, 5, suggestion_type: "public")
      get :daily_picks
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body).size).to eq(3)
    end
  end
end