# == Schema Information
#
# Table name: questions
#
#  id         :bigint           not null, primary key
#  answer     :text
#  ask_count  :integer          default(1)
#  context    :text
#  query      :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  book_id    :bigint
#
FactoryBot.define do
  factory :question do
    query { "What is your name?" }
    answer { Faker::Lorem.paragraph_by_chars(number: 120) }
    context { Faker::Lorem.paragraph_by_chars(number: 120) }
    ask_count { Faker::Number.number(digits: 3) }
  end
end
