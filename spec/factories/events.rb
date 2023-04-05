# frozen_string_literal: true

FactoryBot.define do
  factory :event do
    name { Faker::Restaurant.name }
    location { Faker::Address.full_address }
    description { Faker::Lorem.paragraph }
    start_date { 'Sun, 11 Dec 2022' }
    end_date { 'Mon, 12 Dec 2022' }
    category_list { %w[restaurant bar] }
  end
end
