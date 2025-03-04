FactoryBot.define do
  factory :reference do
    url { "https://example.com" }
    description { "This is a reference description." }
    association :reason
  end
end
