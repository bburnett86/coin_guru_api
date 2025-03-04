class SuggestionsController < ApplicationController
  def daily_picks
    suggestions = Suggestion.picks_of_the_day(3)
    render json: suggestions
  end
end