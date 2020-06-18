FactoryBot.define do
  factory :user, class: User do
    sequence(:email) { |_n| "email-#{srand}@test.com" }
    password { 'a password' }
    password_confirmation { 'a password' }

    factory :admin do
      after(:create) { |user| user.add_role(:admin) }
    end
  end
end
