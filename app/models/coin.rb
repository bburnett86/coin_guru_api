class Coin < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :symbol, presence: true

  has_many :suggestions, dependent: :destroy
  has_many :histories, dependent: :destroy
end
