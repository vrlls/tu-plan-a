# frozen_string_literal: true

FactoryBot.define do
  factory :review do
    title { Faker::Restaurant.name }
    comment { Faker::Restaurant.review }
    score { Faker::Number.decimal(l_digits: 2) }
    user
    place
  end
end
