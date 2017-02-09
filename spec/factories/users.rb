# frozen_string_literal: true
FactoryGirl.define do
  factory :user do
    name Faker::Name.name
    slack_name Faker::Name.name
    slack_id Faker::Name.name # e.g. U041S5G00
    status nil
    deleted false
    role 'developer'

    company
  end
end
