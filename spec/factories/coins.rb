FactoryBot.define do
  factory :coin do
    sequence(:name) { |n| "Bitcoin#{n}" }
    sequence(:symbol) { |n| "BTC#{n}" }
  end
end
