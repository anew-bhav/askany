FactoryBot.define do
  factory :question do
    query { "What is your name?" }
    answer { Faker::Lorem.paragraph_by_chars(number: 120) }
    context { Faker::Lorem.paragraph_by_chars(number: 120) }
    ask_count { Faker::Number.number(digits: 3) }
  end
end
