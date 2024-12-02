# frozen_string_literal: true

FactoryBot.define do
  factory :place do
    name { Faker::Restaurant.name }
    address { Faker::Address.full_address }
    description { Faker::Lorem.paragraph }
    score { 5.0 }
    category_list { %w[restaurant bar] }
  end
end
