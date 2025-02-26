# filepath: /Users/us/Desktop/dev/coin_guru/coin_guru_api/spec/factories/histories.rb
FactoryBot.define do
  factory :history do
    price { 50000.0 }
    created_at { Time.now }
    association :coin
  end
end