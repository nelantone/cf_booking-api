FactoryBot.define do
  factory :booking do
    name          { Faker::Name.first_name }
    date_time     { Faker::Time.forward(days: 7, period: :morning) }
    call_reasons  { Faker::Movies::StarWars.quote }
    mentor_id     { nil }
  end
end
