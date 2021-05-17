FactoryBot.define do
  factory :mentor do
    name      { Faker::Lorem.word }
    time_zone { Faker::Address.time_zone }
  end
end
