FactoryGirl.define do
  factory :company do
    name Faker::Name.name
    wave_business_id Faker::Number.number(7)
  end
end
