FactoryGirl.define do
  factory :invoice do
    hours Faker::Number.number(2)

    customer
    user
  end
end
