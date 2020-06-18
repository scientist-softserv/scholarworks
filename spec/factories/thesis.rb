FactoryBot.define do
  factory :thesis do
    transient do
      user { FactoryBot.create(:user) }
    end
    title { ["Work Title"] }
    creator { ["Work Author"] }
    description { ["Work Description"] }
    resource_type_thesis { ["Abstract"] }
    # admin_set { [FactoryBot.create(:admin_set)] }
  end
end