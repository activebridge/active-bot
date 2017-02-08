# frozen_string_literal: true
FactoryGirl.define do
  factory :customer do
    name Faker::Name.name
    wave_customer_id Faker::Number.number(3)
  end
end
