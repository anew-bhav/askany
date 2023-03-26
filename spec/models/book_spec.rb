# == Schema Information
#
# Table name: books
#
#  id           :bigint           not null, primary key
#  content_type :integer
#  embeddings   :jsonb
#  file_content :jsonb
#  file_data    :jsonb
#  prompt       :text
#  title        :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
require 'rails_helper'

RSpec.describe Book, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
