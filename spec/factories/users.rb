FactoryBot.define do
  factory :user do
    username { "testuser" }
    first_name { "Test" }
    last_name { "User" }
    email { "testuser@example.com" }
    password { "password" }
    password_confirmation { "password" }
  end
end