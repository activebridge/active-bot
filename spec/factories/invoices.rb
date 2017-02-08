# frozen_string_literal: true
FactoryGirl.define do
  factory :invoice do
    hours Faker::Number.number(2)

    customer
    user
  end
end
