FactoryBot.define do
  factory :reason do
    type { "transaction_data" }
    description { "This is a reason description." }
    association :suggestion
  end
end