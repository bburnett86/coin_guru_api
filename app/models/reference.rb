class Reference < ApplicationRecord
  belongs_to :reason
  validates :url, presence: true
  validates :description, presence: true
end
