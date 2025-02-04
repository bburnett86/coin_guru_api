class History < ApplicationRecord
  belongs_to :coin
  
  validates :price, presence: true
  validates :created_at, presence: true
end
