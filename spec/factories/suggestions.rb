FactoryBot.define do
  factory :suggestion do
    association :coin, strategy: :create
    suggestion_type { :public_suggestion }

    trait :custom do
      suggestion_type { :custom }
      association :user
    end
  end
end
