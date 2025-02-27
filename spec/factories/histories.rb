FactoryBot.define do
  factory :history do
    price { 50000.0 }
    created_at { Time.now }
    association :coin
  end
end
