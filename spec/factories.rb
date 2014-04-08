FactoryGirl.define do
  factory :user do
    sequence(:character_name) { |n| "Person #{n}" }
    sequence(:email) { |n| "person_#{n}@example.com"}
    sequence(:character_id) { |n| 90000000 + n }
    password                "qweewq"
    password_confirmation   "qweewq"

    factory :admin do
      admin true
    end
  end
end