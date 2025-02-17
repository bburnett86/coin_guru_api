class Reason < ApplicationRecord
  belongs_to :suggestion
  has_many :references, dependent: :destroy

  validates :type, presence: true
  validates :description, presence: true
end
