FactoryBot.define do
  factory :suggestion do
    suggestion_type { "public" }
    association :coin
    association :user

    trait :custom do
      suggestion_type { "custom" }
    end
  end
end
