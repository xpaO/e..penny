FactoryGirl.define do
  factory :user do
    character_name          "Example Char"
    character_id            98765432 
    email                   "char@example.com"
    password                "qweewq"
    password_confirmation   "qweewq"
  end
end