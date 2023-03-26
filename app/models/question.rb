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
class Question < ApplicationRecord
  belongs_to :book
end
