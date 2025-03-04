class Reason < ApplicationRecord
  enum type: { transaction_data: "transaction_data", rug_pull: "rug_pull", token_supply: "token_supply", social_media_presence: "social_media_presence", black_list: "black_list", summary: "summary" }


  belongs_to :suggestion
  has_many :references, dependent: :destroy

  validates :type, presence: true
  validates :description, presence: true
end
