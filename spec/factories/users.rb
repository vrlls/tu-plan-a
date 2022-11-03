# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    username { Faker::Internet.user }
    email { Faker::Internet.email }
    password_digest { Faker::Internet.password }

    factory :admin do
      after(:create) { |user| user.add_role(:admin) }
    end

    factory :editor do
      after(:create) { |user| user.add_role(:editor) }
    end

    factory :moderator do
      after(:create) { |user| user.add_role(:moderator) }
    end
  end
end
