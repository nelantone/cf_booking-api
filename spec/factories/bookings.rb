FactoryBot.define do
  factory :booking do
    date_time     { Faker::Time.forward(days: 7, period: :morning) }
    call_reason  { Faker::Movies::StarWars.quote }
    mentor_id     { nil }
  end
end
