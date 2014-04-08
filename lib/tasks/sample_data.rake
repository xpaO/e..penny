namespace :db do
desc "Fill database with sample data"
  task populate: :environment do
    admin = User.create!(character_name: "Admin User",
                         character_id: 98754512,
                         email: "admin@example.com",
                         password: "qweewq",
                         password_confirmation: "qweewq",
                         admin: true)
    99.times do |n|
      character_name  = Faker::Name.name
      email = "example-#{n+1}@test.com"
      password  = "password"
      character_id = 90000000 + n
      User.create!(character_name: character_name,
                   character_id: character_id,
                   email: email,
                   password: password,
                   password_confirmation: password)
    end
  end
end