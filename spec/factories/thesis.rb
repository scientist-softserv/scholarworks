FactoryBot.define do
  factory :thesis do
    transient do
      user { FactoryBot.create(:user) }
    end
    title { ["Work Title"] }
    creator { ["Work Author"] }
    description { ["Work Description"] }
    resource_type_thesis { ["Abstract"] }
  end
end