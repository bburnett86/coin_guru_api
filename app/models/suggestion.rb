class Suggestion < ApplicationRecord
  enum suggestion_type: { public_suggestion: "public", custom: "custom" }

  belongs_to :coin
  belongs_to :user, optional: true
  has_many :reasons, dependent: :destroy

validates :suggestion_type, presence: true
  validates :coin_id, presence: true
  validates :user_id, presence: true, if: :custom?
  validate :public_suggestion_cannot_have_user
  validate :custom_suggestion_must_have_user

  def picks_of_the_day(number_of_picks)
    Suggestion.where(suggestion_type: "public").limit(number_of_picks)
  end

  def public_pick_history
    Suggestion.where(suggestion_type: "public").order(created_at: :desc)
  end

  def user_pick_history(user_id)
    Suggestion.where(user_id: user_id).order(created_at: :desc)
  end

  private

  def public_suggestion_cannot_have_user
    if public_suggestion? && user_id.present?
      errors.add(:user_id, "must be blank for public suggestions")
    end
  end

  def custom_suggestion_must_have_user
    if custom? && user_id.blank?
      errors.add(:user_id, "must be present for custom suggestions")
    end
  end
end
