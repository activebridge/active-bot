FactoryGirl.define do
  factory :user do
    name Faker::Name.name
    slack_name Faker::Name.name
    status 'developer'

    company
  end
end
