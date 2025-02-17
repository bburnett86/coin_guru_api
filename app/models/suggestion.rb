class Suggestion < ApplicationRecord
  enum suggestion_type: { public: "public", custom: "custom" }

  belongs_to :coin
  belongs_to :user, optional: true
  has_many :reasons, dependent: :destroy

  validates :suggestion_type, presence: true
  validates :coin_id, presence: true
  validates :user_id, presence: true, if: :custom?

  def picks_of_the_day(number_of_picks)
    Suggestion.where(suggestion_type: "public").limit(number_of_picks)
  end
end
